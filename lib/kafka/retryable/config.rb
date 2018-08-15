# frozen_string_literal: true
module Kafka::Retryable
  # configurator for setting up all the configurable settings for pheromone
  class Config
    extend Dry::Configurable
    # specify message queue settings
    setting :buffer do
      setting :kafka do
        setting :seed_brokers
      end
    end

    setting :failure_handling do
      # specify if failure handling is enabled
      setting :enabled, true
    end

    class << self
      def setup(&block)
        configure(&block)
        setup_waterdrop if config.buffer.kafka.seed_brokers
      end

      def setup_waterdrop
        WaterDrop.setup do |waterdrop_config|
          waterdrop_config.deliver = config.failure_handling.enabled
          waterdrop_config.kafka.seed_brokers = config.buffer.kafka.seed_brokers
        end
      end
    end
  end
end