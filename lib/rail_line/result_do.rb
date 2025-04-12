# frozen_string_literal: true

module RailLine
  module ResultDo
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Enables the use of the automatic handling of results.
    #
    # @example
    #   class MyAwesomeService
    #     include RailLine::ResultDo[:call]
    #
    #     def call
    #       # ...
    #     end
    #   end
    #
    # @param method_names [Array<Symbol>] The names of the methods to wrap.
    # @return [Module] The module that wraps the methods.
    def self.[](*method_names)
      Module.new do
        define_singleton_method(:included) do |base|
          base.extend(RailLine::ResultDo::ClassMethods)

          wrapped_methods = Module.new do
            method_names.each do |method_name|
              define_method(method_name) do |*args, **kwargs|
                base.handle_result { super(*args, **kwargs) }
              end
            end
          end

          base.prepend(wrapped_methods)
          base.singleton_class.prepend(wrapped_methods)
        end
      end
    end

    module ClassMethods
      def handle_result
        ThreadContext.depth_increment

        begin
          handle_success(yield)
        rescue RailLine::FailureError => exception
          handle_failure(exception)
        rescue StandardError => exception
          handle_standard_error(exception)
        ensure
          handle_ensure
        end
      end

      private

      def handle_success(result)
        return result if result.is_a?(RailLine::BaseResult)

        RailLine::Success.new(payload: { return: result }, message: result.to_s)
      end

      def handle_failure(exception)
        raise exception if ThreadContext.nested_depth?

        exception.result
      end

      def handle_standard_error(exception)
        raise exception if ThreadContext.nested_depth?

        message = if exception.message.empty? || exception.message == "StandardError"
          "StandardError: No message"
        else
          exception.message
        end

        RailLine::Failure.new(
          payload: {
            exception:,
            backtrace: exception.backtrace
          },
          message:,
          raise_error: false
        )
      end

      def handle_ensure
        ThreadContext.depth_decrement
        ThreadContext.cleanup if ThreadContext.cleanup?
      end
    end

    def handle_result(&block)
      self.class.handle_result(&block)
    end
  end
end
