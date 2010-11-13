package mockdown.data
{
/**
 *	This class represents a node that will be displayed on-screen.
 */
public class VisualNode extends Node
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function VisualNode()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Position
	//---------------------------------

	/**
	 *	The top offset from the parent node.
	 */
	public var top:String;

	/**
	 *	The bottom offset from the parent node.
	 */
	public var bottom:String;

	/**
	 *	The left offset from the parent node.
	 */
	public var left:String;

	/**
	 *	The right offset from the parent node.
	 */
	public var right:String;
	
	
	//---------------------------------
	//	Dimension
	//---------------------------------

	/**
	 *	The width of the node.
	 */
	public var width:String;
	
	/**
	 *	The height of the node.
	 */
	public var height:String;
}
}
