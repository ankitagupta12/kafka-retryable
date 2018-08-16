module Kafka
  module Retryable
    class << self
      # return config object
      def config
        Config.config
      end

      # Provides a block to override default config
      def setup(&block)
        Config.setup(&block)
      end

      def enabled?
       config.failure_handling.enabled
      end
    end
  end
end


require 'dry-configurable'
require 'dry-validation'
require 'waterdrop'
require 'kafka/retryable/schemas/failure_handler_options'
require 'kafka/retryable/errors/invalid_handling_options'
require 'kafka/retryable/policy_finder'
require 'kafka/retryable/failure_handler'
require 'kafka/retryable/config'
