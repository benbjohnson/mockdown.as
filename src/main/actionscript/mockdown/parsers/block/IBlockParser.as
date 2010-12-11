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
	// function isSingleLineBlock(block:Block):Boolean;

	/**
	 *	Parses a block and alters the component or parent node as needed.
	 *
	 *	@param block      The block to parse.
	 *	@param component  The component definition that this block belongs to.
	 *	@param parent     The node that represents the parent node that was parsed.
	 *
	 *	@return           A flag stating if the block could be parsed.
	 */
	function parse(block:Block, component:Component, parent:Node):void;
}
}
