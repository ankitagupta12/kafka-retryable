module Kafka
  module Retryable::MessageDispatcher
    class Kafka
      def initialize(topic, message)
        @topic = topic
        @message = message
      end

      def perform
        WaterDrop::SyncProducer.call(
          @message,
          { topic: @topic.to_s }
        )
      end
    end
  end
end