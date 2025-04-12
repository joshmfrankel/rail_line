# frozen_string_literal: true

module RailLine
  # Represents a Successful result
  class Success < BaseResult
    # @return [Boolean] Returns true
    def success?
      true
    end
  end
end
