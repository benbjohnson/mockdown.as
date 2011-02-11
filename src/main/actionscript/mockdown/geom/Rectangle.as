package mockdown.geom
{
/**
 *	This class is used to represent the geometry of a rectangle.
 */
public class Rectangle
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Rectangle(x:int=0, y:int=0, width:uint=0, height:uint=0)
	{
		this.x = x;
		this.y = y;
		this.width  = width;
		this.height = height;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Dimensions
	//---------------------------------
	
	/**
	 *	The x coordinate from the top-left corner of the rectangle.
	 */
	public var x:int = 0;
	
	/**
	 *	The y coordinate from the top-left corner of the rectangle.
	 */
	public var y:int = 0;
	
	/**
	 *	The width of the rectangle, in pixels.
	 */
	public var width:uint = 0;
	
	/**
	 *	The height of the rectangle, in pixels.
	 */
	public var height:uint = 0;
}
}
