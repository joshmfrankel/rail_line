# frozen_string_literal: true

RSpec.describe RailLine::ResultDo::ThreadContext do
  describe "depth management" do
    it "tracks depth and state correctly" do
      expect(RailLine::ResultDo::ThreadContext.depth).to eq(0)

      RailLine::ResultDo::ThreadContext.depth_increment
      expect(RailLine::ResultDo::ThreadContext.depth).to eq(1)
      expect(RailLine::ResultDo::ThreadContext.nested_depth?).to be_falsey
      expect(RailLine::ResultDo::ThreadContext.cleanup?).to be_falsey

      RailLine::ResultDo::ThreadContext.depth_increment
      expect(RailLine::ResultDo::ThreadContext.depth).to eq(2)
      expect(RailLine::ResultDo::ThreadContext.nested_depth?).to be_truthy

      RailLine::ResultDo::ThreadContext.depth_decrement
      expect(RailLine::ResultDo::ThreadContext.depth).to eq(1)
      expect(RailLine::ResultDo::ThreadContext.nested_depth?).to be_falsey

      RailLine::ResultDo::ThreadContext.depth_decrement
      expect(RailLine::ResultDo::ThreadContext.depth).to eq(0)
      expect(RailLine::ResultDo::ThreadContext.cleanup?).to be_truthy
    end
  end

  describe ".nested_depth?" do
    context "when the depth is greater than 1" do
      it "returns true" do
        RailLine::ResultDo::ThreadContext.depth = 2

        expect(RailLine::ResultDo::ThreadContext.nested_depth?).to be_truthy
      end
    end

    context "when the depth is 1" do
      it "returns false" do
        RailLine::ResultDo::ThreadContext.depth = 1

        expect(RailLine::ResultDo::ThreadContext.nested_depth?).to be_falsey
      end
    end
  end

  describe ".cleanup?" do
    context "when the depth is less than or equal to 0" do
      it "returns true" do
        RailLine::ResultDo::ThreadContext.depth = 0

        expect(RailLine::ResultDo::ThreadContext.cleanup?).to be_truthy
      end
    end

    context "when the depth is greater than 0" do
      it "returns false" do
        RailLine::ResultDo::ThreadContext.depth = 1

        expect(RailLine::ResultDo::ThreadContext.cleanup?).to be_falsey
      end
    end
  end

  describe ".cleanup" do
    it "sets the depth to nil" do
      RailLine::ResultDo::ThreadContext.depth = 1

      RailLine::ResultDo::ThreadContext.cleanup

      expect(Thread.current[:rail_line_depth]).to be_nil

      # This must be called after the Thread check above due to memoization
      expect(RailLine::ResultDo::ThreadContext.depth).to eq(0)
    end
  end
end
