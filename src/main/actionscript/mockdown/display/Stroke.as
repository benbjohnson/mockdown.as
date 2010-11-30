package mockdown.display
{
/**
 *	This class is used for defining the drawing style of a stroke when drawing
 *	a line or an edge.
 *
 *	@see IRenderObject
 */
public class Stroke
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Stroke():void
	{
		super();
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The thickness of the line, in pixels.
	 */
	public var thickness:uint;

	/**
	 *	The RGB color of the line.
	 */
	public var color:uint;

	/**
	 *	The the alpha transparency value of the stroke. Valid values are between
	 *	0 and 100.
	 */
	public var alpha:uint;
}
}
