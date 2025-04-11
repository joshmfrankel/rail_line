# frozen_string_literal: true

RSpec.describe RailLine::Success do
  describe "adheres to interface contract" do
    it "returns true if the result is a success" do
      result = RailLine::Success.new(message: "Success message")

      expect(result.success?).to be_truthy
      expect(result.failure?).to be_falsey
    end
  end
end
