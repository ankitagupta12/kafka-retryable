module Kafka
  module Retryable
    class InvalidHandlingOptions < StandardError
      def initialize(msg = 'Invalid options', validation_errors: {})
        super("#{msg}: #{validation_errors}")
      end
    end
  end
end