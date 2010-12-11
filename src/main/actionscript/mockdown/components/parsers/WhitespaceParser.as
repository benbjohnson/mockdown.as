package mockdown.components.parsers
{
import mockdown.errors.ParseError;
import mockdown.utils.StringUtil;

import flash.errors.IllegalOperationError;

/**
 *	This class represents a parser that breaks up a document into blocks as
 *	defined by the whitespace indentation.
 */
public class WhitespaceParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function WhitespaceParser()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Parses a string into a tree of blocks which are grouped by indentation.
	 *
	 *	@param content - The string to parse.
	 *	
	 *	@return          A tree of blocks. Each block contains the unindented
	 *	                 content, line number and other parsing information.
	 */
	public function parse(content:String):Block
	{
		// Validate content exists
		if(content == null) {
			throw new ParseError('Content is required for parsing');
        }

		// Setup root & state
		var root:Block  = new Block(null, 0, 0)
		var stack:Array = [root];
		var lastBlock:Block = root;
		var multilineBlock:Block;

		// Loop over lines and group into blocks
		var lines:Array = content.split(/\n/);
		for(var i:int=0; i<lines.length; i++) {
			var lineNumber:int = i+1;
			var line:String = lines[i];

			// Skip line if blank
			if(line.search(/^\s*$/) == 0) {
				multilineBlock = null;
			}
			else {
				// Split of indentation and rest of line
				var match:Array = line.match(/^(\s*)(.+)$/);
				var indentation:String = match[1];
				line = StringUtil.trim(match[2]);
          
				// Throw error if indentation is wrong
				if(indentation.length % 2 != 0) {
					throw new ParseError('You cannot indent an odd number of spaces.', lineNumber)
				}
				// Throw error if tabs were used
				else if(indentation.search(/\t/) != -1) {
					throw new ParseError('You cannot use tabs for indentation.', lineNumber)
				}
          
				// Determine level by indentation
				var level:int = (indentation.length/2) + 1;
				var stackLevel:int = stack.length - 1;
          
				// Adjust stack if level we go down in levels
				if(level < stackLevel) {
					for(var x:int=0; x<(stackLevel-level); x++) {
						stack.pop();
					}
				}
				// Add last block to stack if level goes up by one
				else if(level == stackLevel+1) {
					stack.push(lastBlock)
				}
				// Throw error if we go up by more than one level
				else if(level > stackLevel+1) {
					throw new ParseError('You can not indent multiple levels between lines.', lineNumber)
				}
  
				// Clear multiline block when changing indentation
				if(level != stackLevel) {
					multilineBlock = null;
				}
          
				// If this line extends a multiline block, append the content
				if(multilineBlock && !isSingleLineBlock(line)) {
					multilineBlock.content += "\n" + line;
				}
				// Otherwise create a new block for this line
				else {
					var parent:Block = stack[stack.length-1];
					var block:Block = new Block(parent, level, lineNumber, line);
					parent.addChild(block);
					lastBlock = block;
					multilineBlock = (isSingleLineBlock(line) ? null : block);
				}
			}
		}
        
        return root;
	}

	/**
	 *	Determines if a block is a single line block. This is true if the
	 *	content of the line begins with an exclamation point or a percent sign.
	 *
	 *	@param content  The content of the line.
	 *
	 *	@return         A flag if the line should be a single line block.
	 */
	private function isSingleLineBlock(content:String):Boolean
	{
		// TODO: Move this to the Block parsers
		return content.search(/^(%|!)/) == 0
	}
}
}
