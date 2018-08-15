require 'kafka/retryable/schemas/failure_handler_options'

describe Kafka::Retryable::Schemas::FailureHandlerOptions do
  class ExceptionClass < StandardError; end
  let(:configuration) do
    {
      buffer: :kafka,
      exception_whitelist: [ExceptionClass],
      exception_blacklist: [ExceptionClass],
      dead_letter_queue: 'queue',
      after_failure: ->(message, value) { puts "#{message} #{value}" }
    }
  end
  context 'valid schema' do
    it 'does not return any errors' do
      expect(described_class.call(configuration).errors).to be_empty
    end
  end

  context 'invalid schema' do
    context 'invalid buffer' do
      context 'buffer is not a symbol' do
        let(:invalid_configuration) do
          configuration[:buffer] = 'kafka'
          configuration
        end
        it 'returns invalid buffer' do
          expect(described_class.call(invalid_configuration).errors).to eq(
            buffer: ['Not a valid symbol']
          )
        end
      end

      context 'buffer is not a valid option' do
        let(:invalid_configuration) do
          configuration[:buffer] = :sqs
          configuration
        end
        it 'returns invalid buffer' do
          expect(described_class.call(invalid_configuration).errors).to eq(
            buffer: ["Invalid buffer name Allowable buffer names: kafka\n"]
          )
        end
      end
    end

    context 'invalid exception whitelist' do
      context 'exception whitelist is not a valid class' do
        let(:invalid_configuration) do
          configuration[:exception_whitelist] = [ExceptionClass, 'InvalidExceptionClass']
          configuration
        end
        it 'returns invalid exception whitelist' do
          expect(described_class.call(invalid_configuration).errors).to eq(
            exception_whitelist: { 1 => ['Not a valid class name'] }
          )
        end
      end
    end

    context 'invalid exception blacklist' do
      context 'exception blacklist is not a valid class' do
        let(:invalid_configuration) do
          configuration[:exception_blacklist] = [ExceptionClass, 'InvalidExceptionClass']
          configuration
        end
        it 'returns invalid exception whitelist' do
          expect(described_class.call(invalid_configuration).errors).to eq(
            exception_blacklist: { 1 => ['Not a valid class name'] }
          )
        end
      end
    end

    context 'invalid dead letter queue' do
      context 'exception blacklist is not a string' do
        let(:invalid_configuration) do
          configuration[:dead_letter_queue] = :queue
          configuration
        end
        it 'returns invalid exception whitelist' do
          expect(described_class.call(invalid_configuration).errors).to eq(
            dead_letter_queue: ['must be a string']
          )
        end
      end
      context 'exception blacklist is not a string' do
        let(:invalid_configuration) do
          configuration[:dead_letter_queue] = 'topic-@t1'
          configuration
        end
        it 'returns invalid exception whitelist' do
          expect(described_class.call(invalid_configuration).errors).to eq(
            dead_letter_queue: ['is in invalid format']
          )
        end
      end
    end

    context 'invalid after_failure' do
      context 'after_failure is not a proc' do
        let(:invalid_configuration) do
          configuration[:after_failure] = :after_failure
          configuration
        end
        it 'returns invalid exception whitelist' do
          expect(described_class.call(invalid_configuration).errors).to eq(
            after_failure: ['Not a valid proc']
          )
        end
      end
    end
  end
end
