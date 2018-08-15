require 'kafka/retryable'
describe Kafka::Retryable do
  context 'config' do
    before do
      Kafka::Retryable.setup do |config|
        config.failure_handling.enabled = true
        config.buffer.kafka.seed_brokers = ['kafka://localhost:9092']
      end
    end

    it 'sets the configuration correctly' do
      expect(described_class.config.failure_handling.enabled).to be true
      expect(described_class.config.buffer.kafka.seed_brokers).to eq(['kafka://localhost:9092'])
    end
  end

  context 'setup' do
    before do
      Kafka::Retryable.setup do |config|
        config.failure_handling.enabled = true
      end
    end

    it 'does not error if seed brokers are not present' do
      expect(described_class.config.failure_handling.enabled).to be true
    end
  end

  context 'enabled?' do
    before do
      Kafka::Retryable.setup do |config|
        config.failure_handling.enabled = true
      end
    end

    it 'returns the correct value of enabled' do
      expect(described_class.enabled?).to be true
    end
  end
end