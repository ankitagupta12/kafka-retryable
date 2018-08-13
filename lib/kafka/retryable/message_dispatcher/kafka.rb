module Kafka
  module Retryable::MessageDispatcher
    class Kafka
      def initialize(message, topic)
        @message = message
        @topic = topic
      end

      def perform
        WaterDrop::SyncProducer.call(
          @message,
          { topic: topic.to_s }
        )
      end
    end
  end
end