require 'kafka/retryable/policies/kafka_handler'
require 'kafka/retryable/message_dispatcher/kafka'

describe Kafka::Retryable::Policies::KafkaHandler do
  it 'sends message to kafka' do
    test_double = double(perform: true)
    expect(Kafka::Retryable::MessageDispatcher::Kafka).to receive(:new).
      with('message', 'topic').and_return(test_double)
    expect(test_double).to receive(:perform)
    described_class.new('message', 'topic').perform_failure_recovery
  end
end
