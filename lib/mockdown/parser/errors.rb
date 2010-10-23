module Mockdown
  class Parser
    class ParseError < StandardError
    end

    class IndentationError < ParseError
      def initialize(line_number, message)
        super("#{line_number}: #{message}")
      end
    end
  end
end