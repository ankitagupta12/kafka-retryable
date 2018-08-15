# frozen_string_literal: true

require 'kafka/retryable/message_dispatcher/kafka'
module Kafka
  module Retryable::Policies
    # Policy for storing failed messages in a queue on Kafka
    class KafkaHandler
      def initialize(message, topic)
        @message = message
        @topic = topic
      end

      def perform_failure_recovery
        Kafka::Retryable::MessageDispatcher::Kafka.new(@message, @topic).perform
      end
    end
  end
end