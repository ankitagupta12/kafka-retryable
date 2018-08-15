# frozen_string_literal: true
module Kafka
  module Retryable
    # Error class for invalid failure handling configuration
    class InvalidHandlingOptions < StandardError
      def initialize(msg = 'Invalid options', validation_errors: {})
        super("#{msg}: #{validation_errors}")
      end
    end
  end
end