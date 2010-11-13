package mockdown.errors
{
import mockdown.parsers.Block;

/**
 *	This class represents an error that has occurred during parsing of a block.
 */
public class BlockParseError extends ParseError
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *
	 *	@param block    The block associated with the error.
	 *	@param message  A string associated with the error object.
	 */
	public function BlockParseError(block:Block, message:String="")
	{
		super(message);
		this.block = block;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	private var _block:Block;
	
	/**
	 *	The block associated with the error.
	 */
	public function get block():Block
	{
		return _block;
	}

	public function set block(value:Block):void
	{
		_block = value;

		// Set line number from block.
		if(block) {
			lineNumber = block.lineNumber;
		}
	}
}
}
