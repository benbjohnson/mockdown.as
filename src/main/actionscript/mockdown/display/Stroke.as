package mockdown.display
{
/**
 *	This class is used for defining the drawing style of a stroke when drawing
 *	a line or an edge.
 *
 *	@see RenderObject
 */
public class Stroke
{
	//--------------------------------------------------------------------------
	//
	//	Static Constants
	//
	//--------------------------------------------------------------------------

	/**
	 *	A 1-pixel thick black line.
	 */
	static public const BLACK:Stroke = new Stroke(0x000000, 100, 1);


	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------	
	
	/**
	 *	Constructor.
	 *	
	 *	@param color  The color of the stroke.
	 *	@param alpha  The alpha transparency of the stroke.
	 *	@param color  The thickness of the stroke.
	 */
	public function Stroke(color:uint=0, alpha:uint=100, thickness:uint=1):void
	{
		super();
		this.color = color;
		this.alpha = alpha;
		this.thickness = thickness;
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The RGB color of the line.
	 */
	public var color:uint;

	/**
	 *	The the alpha transparency value of the stroke. Valid values are between
	 *	0 and 100.
	 */
	public var alpha:uint;

	/**
	 *	The thickness of the line, in pixels.
	 */
	public var thickness:uint;
}
}
