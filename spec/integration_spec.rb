# frozen_string_literal: true

# rubocop:disable Lint/UnreachableCode
class DummyDefaultService
  include RailLine::ResultDo

  def self.call
    handle_result do
      "CLASS: Hello, world!"
    end
  end

  def call
    handle_result do
      "INSTANCE: Hello, world!"
    end
  end
end

class DummySuccessService
  include RailLine::ResultDo

  def self.call
    handle_result do
      RailLine::Success.new(message: "CLASS: Success message")
    end
  end

  def call
    handle_result do
      RailLine::Success.new(message: "INSTANCE: Success message")
    end
  end
end

class DummyFailureService
  include RailLine::ResultDo

  def self.call
    handle_result do
      RailLine::Failure.new(message: "CLASS: Failure message")
    end
  end

  def call
    handle_result do
      RailLine::Failure.new(message: "INSTANCE: Failure message")
    end
  end
end

class DummyEarlyReturnFailureService
  include RailLine::ResultDo

  def self.call
    handle_result do
      RailLine::Failure.new(message: "CLASS: Early return failure message")
      # other logic
      RailLine::Success.new(message: "Should not be returned")
    end
  end

  def call
    handle_result do
      RailLine::Failure.new(message: "INSTANCE: Early return failure message")
      # other logic
      RailLine::Success.new(message: "Should not be returned")
    end
  end
end

class DummyDefaultExceptionHandlingService
  include RailLine::ResultDo

  def self.call
    handle_result do
      raise StandardError.new

      # other logic
      RailLine::Success.new(message: "Should not be returned")
    end
  end

  def call
    handle_result do
      raise StandardError.new

      # other logic
      RailLine::Success.new(message: "Should not be returned")
    end
  end
end

class DummyExceptionHandlingService
  include RailLine::ResultDo

  def self.call
    handle_result do
      raise StandardError.new("CLASS: Dummy exception")

      # other logic
      RailLine::Success.new(message: "Should not be returned")
    end
  end

  def call
    handle_result do
      raise StandardError.new("INSTANCE: Dummy exception")

      # other logic
      RailLine::Success.new(message: "Should not be returned")
    end
  end
end

class DummyManualParentExceptionService
  include RailLine::ResultDo

  def self.call
    handle_result do
      DummyManualChildExceptionService.call

      RailLine::Failure.new(message: "CLASS: Not reached")
    end
  end

  def call
    handle_result do
      DummyManualChildExceptionService.new.call

      RailLine::Failure.new(message: "INSTANCE: Not reached")
    end
  end
end

class DummyManualChildExceptionService
  include RailLine::ResultDo

  def self.call
    handle_result do
      raise StandardError.new("CLASS: Manual Dummy exception")
    end
  end

  def call
    handle_result do
      raise StandardError.new("INSTANCE: Manual Dummy exception")
    end
  end
end

class DummyAutomaticSuccessHandlingService
  include RailLine::ResultDo[:call]

  def self.call
    "CLASS: AutomaticSuccessHandling"
  end

  def call
    "INSTANCE: AutomaticSuccessHandling"
  end
end

class DummyAutomaticFailureHandlingService
  include RailLine::ResultDo[:call]

  def self.call
    RailLine::Failure.new(message: "CLASS: AutomaticFailureHandling")

    RailLine::Success.new(message: "Should not be returned")
  end

  def call
    RailLine::Failure.new(message: "INSTANCE: AutomaticFailureHandling")

    RailLine::Success.new(message: "Should not be returned")
  end
end

class DummyAutomaticExceptionHandlingService
  include RailLine::ResultDo[:call]

  def self.call
    raise StandardError.new("CLASS: Automated Dummy exception")

    RailLine::Success.new(message: "Should not be returned")
  end

  def call
    raise StandardError.new("INSTANCE: Automated Dummy exception")

    RailLine::Success.new(message: "Should not be returned")
  end
end

class DummyParentService
  include RailLine::ResultDo[:call]

  def self.call
    DummyChildService.call

    RailLine::Failure.new(message: "CLASS: Not reached")
  end

  def call
    DummyChildService.new.call

    RailLine::Failure.new(message: "INSTANCE: Not reached")
  end
end

class DummyChildService
  include RailLine::ResultDo[:call]

  def self.call
    RailLine::Failure.new(message: "CLASS: DummyChildService")
  end

  def call
    RailLine::Failure.new(message: "INSTANCE: DummyChildService")
  end
end

class DummyParentExceptionService
  include RailLine::ResultDo[:call]

  def self.call
    DummyChildExceptionService.call

    RailLine::Failure.new(message: "CLASS: Not reached")
  end

  def call
    DummyChildExceptionService.new.call

    RailLine::Failure.new(message: "INSTANCE: Not reached")
  end
end

class DummyChildExceptionService
  include RailLine::ResultDo[:call]

  def self.call
    raise StandardError.new("CLASS: Automated Dummy exception")
  end

  def call
    raise StandardError.new("INSTANCE: Automated Dummy exception")
  end
end

class DummyParentHandlerOnlyService
  include RailLine::ResultDo[:call]

  def self.call
    DummyChildWithoutHandlerService.call

    RailLine::Failure.new(message: "CLASS: Not reached")
  end

  def call
    DummyChildWithoutHandlerService.new.call

    RailLine::Failure.new(message: "INSTANCE: Not reached")
  end
end

class DummyChildWithoutHandlerService
  def self.call
    raise StandardError.new("CLASS: Automated Dummy Without Handler exception")
  end

  def call
    raise StandardError.new("INSTANCE: Automated Dummy Without Handler exception")
  end
end
# rubocop:enable Lint/UnreachableCode

RSpec.describe RailLine do
  it "has a version number" do
    expect(RailLine::VERSION).not_to be nil
  end

  context "for explicit handling" do
    context "when no result object is returned" do
      context "for class methods" do
        it "returns a success" do
          result = DummyDefaultService.call

          expect(result).to be_a(RailLine::Success)
          expect(result.message).to eq("CLASS: Hello, world!")
        end
      end

      context "for instance methods" do
        it "returns a success" do
          result = DummyDefaultService.new.call

          expect(result).to be_a(RailLine::Success)
          expect(result.message).to eq("INSTANCE: Hello, world!")
        end
      end
    end

    context "when a success result object is returned" do
      context "for class methods" do
        it "returns a success" do
          result = DummySuccessService.call

          expect(result).to be_a(RailLine::Success)
          expect(result.message).to eq("CLASS: Success message")
          expect(result.success?).to be_truthy
        end
      end

      context "for instance methods" do
        it "returns a success" do
          result = DummySuccessService.new.call

          expect(result).to be_a(RailLine::Success)
          expect(result.message).to eq("INSTANCE: Success message")
          expect(result.success?).to be_truthy
        end
      end
    end

    context "when a failure result object is returned" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyFailureService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("CLASS: Failure message")
          expect(result.failure?).to be_truthy
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyFailureService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("INSTANCE: Failure message")
          expect(result.failure?).to be_truthy
        end
      end
    end

    context "when a failure result object is returned early" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyEarlyReturnFailureService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("CLASS: Early return failure message")
          expect(result.failure?).to be_truthy
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyEarlyReturnFailureService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("INSTANCE: Early return failure message")
          expect(result.failure?).to be_truthy
        end
      end
    end

    context "when an exception is raised without a message" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyDefaultExceptionHandlingService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("StandardError: No message")
          expect(result.failure?).to be_truthy
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyDefaultExceptionHandlingService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("StandardError: No message")
          expect(result.failure?).to be_truthy
        end
      end
    end

    context "when an exception is raised" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyExceptionHandlingService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("CLASS: Dummy exception")
          expect(result.failure?).to be_truthy
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyExceptionHandlingService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("INSTANCE: Dummy exception")
          expect(result.failure?).to be_truthy
        end
      end
    end

    context "when an exception is raised from a child service" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyManualParentExceptionService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("CLASS: Manual Dummy exception")
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyManualParentExceptionService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("INSTANCE: Manual Dummy exception")
        end
      end
    end
  end

  context "for automatic handling" do
    context "for success" do
      context "for class methods" do
        it "returns a success" do
          result = DummyAutomaticSuccessHandlingService.call

          expect(result).to be_a(RailLine::Success)
          expect(result.message).to eq("CLASS: AutomaticSuccessHandling")
        end
      end

      context "for instance methods" do
        it "returns a success" do
          result = DummyAutomaticSuccessHandlingService.new.call

          expect(result).to be_a(RailLine::Success)
          expect(result.message).to eq("INSTANCE: AutomaticSuccessHandling")
        end
      end
    end

    context "for failure" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyAutomaticFailureHandlingService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("CLASS: AutomaticFailureHandling")
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyAutomaticFailureHandlingService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("INSTANCE: AutomaticFailureHandling")
        end
      end
    end

    context "for exception" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyAutomaticExceptionHandlingService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("CLASS: Automated Dummy exception")
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyAutomaticExceptionHandlingService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("INSTANCE: Automated Dummy exception")
        end
      end
    end

    context "when a failure is raised from a child service" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyParentService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("CLASS: DummyChildService")
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyParentService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("INSTANCE: DummyChildService")
        end
      end
    end

    context "when an exception is raised from a child service" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyParentExceptionService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("CLASS: Automated Dummy exception")
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyParentExceptionService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("INSTANCE: Automated Dummy exception")
        end
      end
    end

    context "when a failure is raised from a child service that only the parent service has a handler for" do
      context "for class methods" do
        it "returns a failure" do
          result = DummyParentHandlerOnlyService.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("CLASS: Automated Dummy Without Handler exception")
        end
      end

      context "for instance methods" do
        it "returns a failure" do
          result = DummyParentHandlerOnlyService.new.call

          expect(result).to be_a(RailLine::Failure)
          expect(result.message).to eq("INSTANCE: Automated Dummy Without Handler exception")
        end
      end
    end
  end
end
