# frozen_string_literal: true
module Kafka
  module Retryable
    # Error class if the policy cannot be found
    class InvalidPolicy < StandardError; end
  end
end