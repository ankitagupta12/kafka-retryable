require 'kafka/retryable'
require 'kafka/retryable/schemas/failure_handler_options'
require 'kafka/retryable/errors/invalid_handling_options'

module Kafka
  module Retryable
    module HandleFailure
      module ClassMethods
        def failure_handler(failure_handling_options)
          validate_options(failure_handling_options)
          @@failure_configuration ||= {}
          @@failure_configuration[to_s] = failure_handling_options
        end

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
        def handle_failure(message)
          yield
        rescue => error
          run_failure_hooks(error, message)
        end

        def failure_configuration
          @@failure_configuration
        end

        def run_failure_hooks(error, message)
          configuration == failure_configuration[self.class.name]
          return if error_in_blacklist?(error, configuration[:exception_blacklist])
          return unless error_in_whitelist?(error, configuration[:exception_blacklist])

          policy = PolicyFinder.find_by(configuration[:buffer])
          policy.new(configuration[:dead_letter_queue], message).perform_failure_recovery
        end

        def error_in_blacklist?(error, exception_blacklist)
          return false if exception_blacklist.empty?
          exception_blacklist.include?(error)
        end

        def error_in_whitelist?(error, exception_whitelist)
          return true if exception_whitelist.empty?
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

