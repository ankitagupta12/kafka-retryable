module Kafka
  module Retryable::Policies
    class KafkaHandler
      def initialize(message, topic)
        @message = message
        @topic = topic
      end

      def perform_failure_recovery
        MessageDispatcher::Kafka.new(@message, @topic).perform
      end
    end
  end
end