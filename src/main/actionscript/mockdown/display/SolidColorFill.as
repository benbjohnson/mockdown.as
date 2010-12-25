package mockdown.display
{
/**
 *	This class is used for defining a polygon fill that uses a single color.
 *
 *	@see RenderObject
 */
public class SolidColorFill extends Fill
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *
	 *	@param color  The color of the fill.
	 *	@param alpha  The alpha transparency value of the fill.
	 */
	public function SolidColorFill(color:uint=0x000000, alpha:uint=100):void
	{
		super();
		this.color = color;
		this.alpha = alpha;
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The RGB color of the fill.
	 */
	public var color:uint;

	/**
	 *	The the alpha transparency value of the fill. Valid values are between
	 *	0 and 100.
	 */
	public var alpha:uint;
}
}
