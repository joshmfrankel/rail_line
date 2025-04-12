# frozen_string_literal: true

module RailLine
  # Represents a Failed result
  class Failure < BaseResult
    attr_reader :raise_error

    # @param payload [Hash] The payload of the result
    # @param message [String] The message of the result
    # @param raise_error [Boolean] Raise an error when the failure is instantiated
    def initialize(payload: {}, message: nil, raise_error: true)
      @raise_error = raise_error

      super(payload:, message:)
    end

    # @return [Boolean] Returns false
    def success?
      false
    end
  end
end
