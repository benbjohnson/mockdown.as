package mockdown.components.drawing
{
import mockdown.components.VisualNode;

/**
 *	This class represents a visual rectangle.
 */
public class Rectangle extends VisualNode
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Rectangle()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Corner radius
	//---------------------------------
	
	/**
	 *	The corner radius of all the corners.
	 */
	public var radius:String;
	
	/**
	 *	The corner radius of the top-left corner.
	 */
	public var radiusTl:String;
	
	/**
	 *	The corner radius of the top-right corner.
	 */
	public var radiusTr:String;
	
	/**
	 *	The corner radius of the bottom-left corner.
	 */
	public var radiusBl:String;
	
	/**
	 *	The corner radius of the bottom-right corner.
	 */
	public var radiusBr:String;
}
}
