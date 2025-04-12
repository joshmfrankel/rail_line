# frozen_string_literal: true

module RailLine
  module ResultDo
    def self.included(base)
      base.extend(ClassMethods)
    end

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

    def self.depth
      Thread.current[:rail_line_depth] ||= 0
    end

    def self.depth=(value)
      Thread.current[:rail_line_depth] = value
    end

    def self.cleanup
      Thread.current[:rail_line_depth] = nil
    end

    def self.nested_depth?
      depth > 1
    end

    module ClassMethods
      def handle_result
        RailLine::ResultDo.depth += 1

        begin
          result = yield

          return result if result.is_a?(RailLine::BaseResult)

          RailLine::Success.new(payload: { return: result }, message: result.to_s)
        rescue RailLine::FailureError => exception
          raise exception if RailLine::ResultDo.nested_depth?

          exception.result
        rescue StandardError => exception
          raise exception if RailLine::ResultDo.nested_depth?

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
        ensure
          RailLine::ResultDo.depth -= 1
          ResultDo.cleanup if ResultDo.depth <= 0
        end
      end
    end

    def handle_result(&block)
      self.class.handle_result(&block)
    end
  end
end
