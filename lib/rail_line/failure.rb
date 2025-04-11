# frozen_string_literal: true

module RailLine
  class Failure < BaseResult
    attr_reader :raise_error

    def initialize(payload: {}, message: nil, raise_error: true)
      @raise_error = raise_error

      super(payload:, message:)
    end

    def success?
      false
    end
  end
end
