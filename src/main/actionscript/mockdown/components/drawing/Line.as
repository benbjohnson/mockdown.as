package mockdown.components.drawing
{
import mockdown.components.VisualNode;

/**
 *	This class represents a visual line.
 */
public class Line extends VisualNode
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Line()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Point 1
	//---------------------------------
	
	/**
	 *	The relative position of the first point from the top.
	 */
	public var top1:String;
	
	/**
	 *	The relative position of the first point from the bottom.
	 */
	public var bottom1:String;
	
	/**
	 *	The relative position of the first point from the left.
	 */
	public var left1:String;
	
	/**
	 *	The relative position of the first point from the right.
	 */
	public var right1:String;
	
	
	//---------------------------------
	//	Point 2
	//---------------------------------
	
	/**
	 *	The relative position of the second point from the top.
	 */
	public var top2:String;
	
	/**
	 *	The relative position of the second point from the bottom.
	 */
	public var bottom2:String;
	
	/**
	 *	The relative position of the second point from the left.
	 */
	public var left2:String;
	
	/**
	 *	The relative position of the second point from the right.
	 */
	public var right2:String;
	
}
}
