# frozen_string_literal: true

module RailLine
  module ResultDo
    # Manages the current depth of the RailLine context for nested
    # handle_result calls. Captured within the current thread.
    module ThreadContext
      # @return [Integer] The current depth of the RailLine context
      def self.depth
        Thread.current[:rail_line_depth] ||= 0
      end

      # @param value [Integer] The value to set the depth to
      def self.depth=(value)
        Thread.current[:rail_line_depth] = value
      end

      # Increments the depth of the RailLine context
      # @return [Integer] The new depth of the RailLine context
      def self.depth_increment
        self.depth += 1
      end

      # Decrements the depth of the RailLine context
      # @return [Integer] The new depth of the RailLine context
      def self.depth_decrement
        self.depth -= 1
      end

      # Cleans up the RailLine context by resetting the depth
      def self.cleanup
        Thread.current[:rail_line_depth] = nil
      end

      # @return [Boolean] Whether the RailLine context is nested
      def self.nested_depth?
        depth > 1
      end

      # @return [Boolean] Whether the RailLine context should be cleaned up
      def self.cleanup?
        depth <= 0
      end
    end
  end
end
