# frozen_string_literal: true
module Kafka::Retryable
  module Schemas
    # Schema for validating failure handling options
    FailureHandlerOptions = Dry::Validation.Schema do
      VALID_BUFFERS = %i(kafka).freeze
      TOPIC_REGEXP = /\A(\w|\-|\.)+\z/

      configure do
        config.messages_file = File.join(
          Pathname.new(File.expand_path('../../../../../', __FILE__)), 'config', 'errors.yml'
        )

        # Validator to check the buffer name
        def valid_buffer?(buffer)
          VALID_BUFFERS.include?(buffer)
        end

        # Validate if the option is a string
        def sym?(option)
          option.is_a? Symbol
        end

        #  Check if the option passed in is a valid class
        def klass?(option)
          Object.const_defined?(option.to_s)
        end

        # Check if the option passed in is a valid proc
        def is_a_proc?(option)
          option.respond_to?(:call)
        end
      end

      required(:buffer).filled { sym? & valid_buffer? }
      optional(:exception_whitelist).filled { each(:klass?) }
      optional(:exception_blacklist).filled { each(:klass?) }
      required(:dead_letter_queue).filled(:str?, format?: TOPIC_REGEXP)
      optional(:after_failure).maybe { is_a_proc? }
    end
  end
end