# frozen_string_literal: true

RSpec.describe RailLine::FailureError do
  describe "wraps initializer with result" do
    it "returns the result" do
      failure_result = RailLine::FailureError.new(
        RailLine::Failure.new(message: "Failure message", raise_error: false)
      )

      expect(failure_result.result).to be_a(RailLine::Failure)
      expect(failure_result.result.message).to eq("Failure message")
    end
  end
end
