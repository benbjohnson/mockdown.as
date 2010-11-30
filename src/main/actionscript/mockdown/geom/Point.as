package mockdown.geom
{
/**
 *	This class is used to represent a single coordinate.
 */
public class Point
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Point(x:int=0, y:int=0)
	{
		this.x = x;
		this.y = y;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The x coordinate from the top-left corner of the rectangle.
	 */
	public var x:int = 0;
	
	/**
	 *	The y coordinate from the top-left corner of the rectangle.
	 */
	public var y:int = 0;
}
}
