# frozen_string_literal: true
module Kafka::Retryable
  module Schemas
    # Schema for validating failure handling options
    FailureHandlerOptions = Dry::Validation.Schema do
      VALID_BUFFERS = %i(kafka).freeze

      configure do
        config.messages_file = File.join(
          Pathname.new(File.expand_path('../../../../../', __FILE__)), 'config', 'errors.yml'
        )

        # Validator to check the buffer name
        def valid_buffer?(buffer)
          VALID_BUFFERS.include?(buffer)
        end

        def sym?(option)
          option.is_a? Symbol
        end

        def klass?(option)
          Object.const_defined?(option.to_s)
        end
      end

      required(:buffer).filled { sym? & valid_buffer? }
      optional(:exception_whitelist).filled { each(:str?) }
      optional(:exception_blacklist).filled { each(:klass?) }
      optional(:dead_letter_queue).maybe { sym? }
    end
  end
end