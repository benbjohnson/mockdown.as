package mockdown.parsers.block
{
import mockdown.components.Node;
import mockdown.parsers.Block;

/**
 *	This interface defines methods for parsing blocks.
 */
public interface IBlockParser
{
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The document parser that invoked this block parser.
	 */
	public function get documentParser():DocumentParser;
	public function set documentParser(value:DocumentParser):void;
	
	                                                             
	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	                                                                           

	/**
	 *	Tests whether a block is completely parsed. This is used to define
	 *	single-line blocks.
	 *
	 *	@param block  The block to check.
	 *
	 *	@return       True if the next line of the block should not be appended
	 *                to the content of this block. False if the next line
	 *	              should be read to possibly append.
	 */
	function isSingleLineBlock(block:Block):Boolean;

	/**
	 *	Parses a block into a node object.
	 *
	 *	@param block  The block to parse.
	 *
	 *	@return       A node generated from parsing the block.
	 */
	function parse(block:Block):Node;
}
}
