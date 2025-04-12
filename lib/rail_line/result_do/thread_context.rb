# frozen_string_literal: true

module RailLine
  module ResultDo
    module ThreadContext
      def self.depth
        Thread.current[:rail_line_depth] ||= 0
      end

      def self.depth=(value)
        Thread.current[:rail_line_depth] = value
      end

      def self.depth_increment
        self.depth += 1
      end

      def self.depth_decrement
        self.depth -= 1
      end

      def self.cleanup
        Thread.current[:rail_line_depth] = nil
      end

      def self.nested_depth?
        depth > 1
      end

      def self.cleanup?
        depth <= 0
      end
    end
  end
end
