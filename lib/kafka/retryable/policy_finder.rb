# frozen_string_literal: true
require 'kafka/retryable/policies/kafka_handler'
require 'kafka/retryable/errors/invalid_policy'

module Kafka
  module Retryable
    # Find policy based on the failure handler settings
    class   PolicyFinder
      POLICY_MAPPING = {
        kafka: Kafka::Retryable::Policies::KafkaHandler
      }.freeze

      def self.find_by(buffer)
        POLICY_MAPPING[buffer].tap do |policy|
          raise Kafka::Retryable::InvalidPolicy.new('Policy not found') unless policy
        end
      end
    end
  end
end