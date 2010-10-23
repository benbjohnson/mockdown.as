module Mockdown
  class Parser
    # The BlockParser parses logical blocks of code in a whitespace-aware text
    # file. Blocks can be organized in several ways:
    #
    # 1. A line that is indented or unindented further than the previous line.
    # 2. A line that returns true when yielded by the &block passed to parse().
    #
    # Blocks are organized hierarchically by indentation so that they can be
    # easily parsed.
    class BlockParser
      #########################################################################
      #
      # Public Methods
      #
      #########################################################################

      # Public: Parses a whitespace aware text file into a hierarchy of logical
      # blocks.
      #
      # content - The white-space aware text to parse.
      #
      # Example:
      #
      #   content = IO.read('homepage.mkd')
      #   parser  = Mockdown::Parser::BlockParser.new()
      #   root    = parser.parse(content)
      #
      # Returns a Mockdown::Parser::Block.
      def parse(content, options={})
        if content.nil?
          raise ParseError.new(0, 'Content is required for parsing')
        end
        
        # Setup root & state
        root  = Block.new(nil, 0, nil)
        stack = [root]
        last_block = root
        multiline_block = nil
        
        # Loop over lines and group into blocks
        lines = content.split(/\n/)
        lines.each_index do |index|
          line_number = index+1
          line = lines[index]

          # Skip line if blank
          if line.index(/^\s*$/) == 0
            multiline_block = nil
            next
          end

          # Split of indentation and rest of line
          m, indentation, line = *line.match(/^(\s*)(.+)$/)
          
          # Throw error if indentation is wrong
          if indentation.length % 2 != 0
            raise IndentationError.new(line_number, 'You cannot indent an odd number of spaces.')
          # Throw error if tabs were used
          elsif indentation.index(/\t/)
            raise IndentationError.new(line_number, 'You cannot use tabs for indentation.')
          end
          
          # Clean content
          line.strip!
          
          # Determine level by indentation
          level = (indentation.length/2) + 1
          stack_level = stack.length - 1
          
          # Adjust stack if level we go down in levels
          if level < stack_level
            (stack_level-level).times {|x| stack.pop}
          # Add last block to stack if level goes up by one
          elsif level == stack_level+1
            stack.push(last_block)
          # Throw error if we go up by more than one level
          elsif level > stack_level+1
            raise IndentationError.new(line_number, 'You can not indent multiple levels between lines.')
          end
  
          # Clear multiline block when changing indentation
          multiline_block = nil if level != stack_level
          
          # If this line extends a multiline block, append the content
          if !multiline_block.nil? && !single_line_block?(line)
            multiline_block.content += "\n#{line}"
            
          # Otherwise create a new block for this line
          else
            parent = stack.last
            block = Block.new(parent, level, line_number, line)
            parent.children << block
            last_block = block
            multiline_block = (single_line_block?(line) ? nil : block)
          end
          
        end
        
        return root
      end
      

      #########################################################################
      #
      # Protected Methods
      #
      #########################################################################

      protected
      
      # Determines if a block is a single line block. This is true if the
      # content of the line begins with an exclamation point or a percent sign.
      #
      # content - The content of the line.
      #
      # Returns true if the line should be a single line block. Returns false
      # if line could be a part of a previous multiline block.
      def single_line_block?(content)
        content.index(/^(%|!)/) == 0
      end
    end
  end
end