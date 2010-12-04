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
	function isBlockComplete(block:Block):Boolean

	/**
	 *	Parses a block into a node object.
	 *
	 *	@param block  The block to parse.
	 *
	 *	@return       A node generated from parsing the block.
	 */
	function parse(block:Block):Node
}
}
