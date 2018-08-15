require 'kafka/retryable/message_dispatcher/kafka'

describe Kafka::Retryable::MessageDispatcher::Kafka do
  context 'sends message to Kafka' do
    let(:topic) { 't1' }
    let(:message) { 'message' }
    it 'should use waterdrop to send message to kafka' do
      allow(WaterDrop::SyncProducer).to receive(:call)
      described_class.new(topic, message).perform
      expect(WaterDrop::SyncProducer).to have_received(:call).with(
        'message',
        { topic: 't1' }
      )
    end
  end
end
