require 'kafka/retryable/policy_finder'
describe Kafka::Retryable::PolicyFinder do
  context 'when policy is found' do
    it 'returns the policy class name' do
      expect(described_class.find_by(:kafka)).to eq(Kafka::Retryable::Policies::KafkaHandler)
    end
  end

  context 'when policy is not found' do
    it 'raises an InvalidPolicy error' do
      expect{ described_class.find_by(:sqs) }.to raise_error(
        Kafka::Retryable::InvalidPolicy, /Policy not found/
      )
    end
  end
end