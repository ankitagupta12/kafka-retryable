require 'kafka/retryable'
require 'kafka/retryable/schemas/failure_handler_options'
require 'kafka/retryable/errors/invalid_handling_options'
require 'kafka/retryable/policy_finder'
module Kafka
  module Retryable
    module HandleFailure
      module ClassMethods
        # Define failure handler configuration here
        #     failure_handler buffer: :kafka,
        #                     dead_letter_queue: :topic_t1,
        #                     exception_blacklist: [Karafka::InvalidMessageError],
        #                     after_failure: ->(error, _) { Bugsnag.notify(error) }
        #
        # Only buffer and dead_letter_queue are required arguments
        def failure_handler(failure_handling_options)
          validate_options(failure_handling_options)
          @@failure_configuration ||= {}
          @@failure_configuration[to_s] = failure_handling_options
        end

        # @@failure_configuration is stored in a hash when the class is first loaded
        def failure_configuration
          @@failure_configuration
        end

        # Validate if the configuration passed is a valid one
        #  If the configuration is invalid, raise exception
        def validate_options(failure_handling_options)
          options_validator = Kafka::Retryable::Schemas::FailureHandlerOptions.call(
            failure_handling_options
          )
          return if options_validator.success?
          raise Kafka::Retryable::InvalidHandlingOptions.new(
            validation_errors: options_validator.errors
          )
        end
      end

      module InstanceMethods
        # The message consumption logic can be passed in to this method as a block
        # If any exceptions occur within the message consumption logic, then this
        # block will be responsible for error handling, buffering, and retry logic

        # @param message [Hash|String] this should be the exact message the needs to be
        # sent to Kafka. kafka_retryable does not perform any modifications on this
        # message and sends it as it is to Kafka
        def handle_failure(message)
          yield
        rescue => error
          run_failure_hooks(error, message)
          run_after_failure_action(error, message)
        end

        private

        # Find the failure policy based on the buffer, and execute the logic within the policy
        # @param error [Class]
        # @param message [Hash|String]
        def run_failure_hooks(error, message)
          return if error_in_blacklist?(error, configuration[:exception_blacklist])
          return unless error_in_whitelist?(error, configuration[:exception_whitelist])

          policy = PolicyFinder.find_by(configuration[:buffer])
          policy.new(configuration[:dead_letter_queue], message).perform_failure_recovery
        end

        # Run any post-processing logic here, e.g. notifying Bugsnag
        # @param error [Class]
        # @param message [Hash|String]
        def run_after_failure_action(error, message)
          configuration[:after_failure].call(error, message)
        end

        # Fetch configuration for the class
        def configuration
          @configuration ||= failure_configuration[self.class.name]
        end

        # @@failure_configuration is stored in a hash when the class is first loaded
        def failure_configuration
          self.class.failure_configuration
        end

        # This is false by default for all error classes
        # It means that all error classes will trigger failure handling unless they are
        # specified in the blacklist
        def error_in_blacklist?(error, exception_blacklist)
          return false if (exception_blacklist || []).empty?
          exception_blacklist.include?(error)
        end

        # This is true by default for all error classes
        # It means that all error classes will trigger failure handling by default
        # If this list exists then only the errors in this list will trigger failure handling
        def error_in_whitelist?(error, exception_whitelist)
          return true if (exception_whitelist || []).empty?
          !exception_whitelist.include?(error)
        end
      end

      def self.included(base)
        base.send :extend, ClassMethods
        base.send :include, InstanceMethods
      end
    end
  end
end

