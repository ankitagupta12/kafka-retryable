require 'kafka/retryable/handle_failure'
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

      # @return [String] root path of this gem
      def gem_root
        Pathname.new(File.expand_path('../..', __FILE__))
      end
    end
  end
end
