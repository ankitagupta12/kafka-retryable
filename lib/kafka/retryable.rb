require 'kafka/retryable/handle_failure'
require 'kafka/retryable/config'
require 'waterdrop'
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
