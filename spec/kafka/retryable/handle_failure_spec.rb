require 'kafka/retryable/failure_handler'
describe Kafka::Retryable::FailureHandler do
  class Consumer
    include Kafka::Retryable::FailureHandler
  end

  before do
    Kafka::Retryable.setup do |config|
      config.failure_handling.enabled = true
      config.buffer.kafka.seed_brokers = ['kafka://localhost:9092']
    end
  end

  context '#configure_handler' do
    it 'will initialize failure configuration for valid config' do
      Consumer.class_eval do
        configure_handler buffer: :kafka,
                        dead_letter_queue: 'queue',
                        after_failure: ->(message, value) { puts "#{message} #{value}" }
      end
      expect(Consumer.failure_configuration).to include(
        'Consumer' => hash_including(
          buffer: :kafka,
          dead_letter_queue: 'queue'
        )
      )
    end

    it 'will raise error for invalid configuration' do
      expect do
        Consumer.class_eval do
          configure_handler buffer: 'kafka',
                          dead_letter_queue: 'queue',
                          after_failure: ->(message, value) { puts "#{message} #{value}" }

        end
      end.to raise_error(
        Kafka::Retryable::InvalidHandlingOptions, /Invalid options/
      )
    end
  end

  context '#handle_failure' do
    before do
      Consumer.class_eval do
        configure_handler buffer: :kafka,
                        dead_letter_queue: 'queue',
                        after_failure: ->(message, value) { puts "#{message} #{value}" }
      end
    end
    context 'policy kafka' do
      before do
        allow(WaterDrop::SyncProducer).to receive(:call)
      end

      context 'in case of failures' do
        let!(:consumer_instance_override) do
          class Consumer
            def consume
              handle_failure(message.to_json) do
                raise StandardError
                puts message
              end
            end

            def message
              { message_text: 'test' }
            end
          end
        end

        it 'sends message via WaterDrop to Kafka' do
          Consumer.new.consume
          expect(WaterDrop::SyncProducer).to have_received(:call).with(
            { message_text: 'test' }.to_json, { topic: 'queue' }
          )
        end
      end

      context 'in case of no failures' do
        before do
          class Consumer
            def consume
              handle_failure(message.to_json) do
                puts message
              end
            end

            def message
              { message_text: 'test' }
            end
          end
        end

        it 'does not send message via WaterDrop to Kafka' do
          Consumer.new.consume
          expect(WaterDrop::SyncProducer).not_to have_received(:call)
        end
      end
    end
  end
end