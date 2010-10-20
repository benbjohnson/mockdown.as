module Mockdown
  module Parser
    # Represents a logical block of lines in a Mockdown file. This is used
    # internally by the parser.
    class Block
      def initialize(parent, level, line_number, content=nil)
        self.parent      = parent
        self.level       = level
        self.line_number = line_number
        self.content     = content
        self.children    = []
      end
      
      # The parent block.
      attr_accessor :parent
      
      # The line number that the block starts on.
      attr_accessor :line_number

      # The indentation level
      attr_accessor :level
      
      # The unindented content of the block.
      attr_accessor :content

      # The indented children of the block.
      attr_accessor :children
      
      def to_s
        "<#{level}: content>"
      end
    end
  end
end