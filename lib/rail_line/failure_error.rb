# frozen_string_literal: true

module RailLine
  # Controls flow of RailLine when encountering a RailLine::Failure
  class FailureError < StandardError
    attr_reader :result

    # @param result [RailLine::Failure] The result that caused the error
    def initialize(result)
      @result = result

      super(result.message)
    end
  end
end
