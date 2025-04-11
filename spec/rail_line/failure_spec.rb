# frozen_string_literal: true

RSpec.describe RailLine::Failure do
  describe "adheres to interface contract" do
    it "returns true if the result is a failure" do
      result = RailLine::Failure.new(message: "Failure message", raise_error: false)

      expect(result.success?).to be_falsey
      expect(result.failure?).to be_truthy
      expect(result.raise_error).to be_falsey
    end
  end

  describe "#raise_error" do
    it "raises RailLine::FailureError" do
      expect do
        RailLine::Failure.new(message: "Failure message", raise_error: true)
      end.to raise_error(RailLine::FailureError)
    end

    it "does not raise RailLine::FailureError" do
      expect do
        RailLine::Failure.new(message: "Failure message", raise_error: false)
      end.not_to raise_error
    end
  end
end
