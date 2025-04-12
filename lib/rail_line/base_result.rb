# frozen_string_literal: true

module RailLine
  class BaseResult
    attr_reader :payload, :message

    # @param payload [Hash] The payload of the result
    # @param message [String] The message of the result
    def initialize(payload: {}, message: nil)
      @payload = payload
      @message = message

      handle_failure
    end

    # @return [Boolean] Returns true if the result is a failure
    def failure?
      !success?
    end

    private

    def handle_failure
      return unless failure?
      return unless respond_to?(:raise_error) && raise_error

      raise FailureError.new(self)
    end
  end
end
