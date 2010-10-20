module Mockdown
  module Parser
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
      # file  - The file to parse.
      # new_block? - A block that is called for each line to determine if a new
      #              block should be created. This is not called when lines
      #              change indentation levels.
      #
      # Examples
      #
      #   parser = Mockdown::Parser::BlockParser.new()
      #   block = parser.parse('homepage.mkdn') do |block, line|
      #     if line[0] == "%"
      #       return true
      #     elsif line[0] == "*" && block.content[0] != "*"
      #       return true
      #     else
      #       return false
      #     end
      #   end
      #
      # Returns a Mockdown::Parser::Block.
      def parse(options={}, &f)
        # If a string was passed in, use it as the content
        if options.is_a?(String)
          content = options
        # Use content passed in through options
        elsif options['content']
          content = options['content']
        # If we didn't receive any content then raise an error
        else
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
          m, indentation, content = *line.match(/^(\s*)(.+)$/)
          
          # Throw error if indentation is wrong
          if indentation.length % 2 != 0
            raise IndentationError.new(line_number, 'You cannot indent an odd number of spaces.')
          # Throw error if tabs were used
          elsif indentation.index(/\t/)
            raise IndentationError.new(line_number, 'You cannot use tabs for indentation.')
          end
          
          # Clean content
          content.strip!
          
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
          if !multiline_block.nil? && !single_line_block?(content)
            multiline_block.content += "\n#{content}"
            
          # Otherwise create a new block for this line
          else
            parent = stack.last
            block = Block.new(parent, level, line_number, content)
            parent.children << block
            last_block = block
            multiline_block = (single_line_block?(content) ? nil : block)
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