# frozen_string_literal: true

module RailLine
  class FailureError < StandardError
    attr_reader :result

    def initialize(result)
      @result = result

      super(result.message)
    end
  end
end
