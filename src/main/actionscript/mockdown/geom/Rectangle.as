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
	public function Rectangle(x:int=0, y:int=0,
							  width:uint=0, height:uint=0,
							  borderTopLeftRadius:uint=0,
							  borderTopRightRadius:uint=0,
							  borderBottomLeftRadius:uint=0,
							  borderBottomRightRadius:uint=0,
							)
	{
		this.x = x;
		this.y = y;

		this.width  = width;
		this.height = height;

		this.borderTopLeftRadius     = borderTopLeftRadius;
		this.borderTopRightRadius    = borderTopRightRadius;
		this.borderBottomLeftRadius  = borderBottomLeftRadius;
		this.borderBottomRightRadius = borderBottomRightRadius;
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


	//---------------------------------
	//	Border radius
	//---------------------------------
	
	/**
	 *	The border radius of the top left corner.
	 */
	public var borderTopLeftRadius:uint = 0;
	
	/**
	 *	The border radius of the top right corner.
	 */
	public var borderTopRightRadius:uint = 0;
	
	/**
	 *	The border radius of the bottom left corner.
	 */
	public var borderBottomLeftRadius:uint = 0;
	
	/**
	 *	The border radius of the bottom right corner.
	 */
	public var borderBottomRightRadius:uint = 0;
}
}
