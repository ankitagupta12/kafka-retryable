module Kafka
  module Retryable
    class PolicyFinder
      POLICY_MAPPING = {
        kafka: Kafka::Retryable::Policies::KafkaHandler
      }.freeze

      def self.find_by(buffer)
        POLICY_MAPPING[buffer].tap do |policy|
          InvalidPolicy.new('Policy not found') unless policy
        end
      end
    end
  end
end