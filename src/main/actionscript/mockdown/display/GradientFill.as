package mockdown.display
{
/**
 *	This class is used for defining a polygon fill that uses a set of gradiated
 *	colors.
 *
 *	@see RenderObject
 */
public class GradientFill extends Fill
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *
	 *	@param type    The type of gradient.
	 *	@param colors  A list of colors.
	 *	@param alphas  A list of alphas associated with the colors.
	 */
	public function GradientFill(type:String="linear", colors:Array=null,
								 alphas:Array=null, angle:uint=0):void
	{
		super();
		this.type   = type;
		this.colors = colors;
		this.alphas = alphas;
		this.angle  = angle;
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The type of gradient. This can be either <code>linear<code> or
	 *	<code>radial</code>.
	 */
	public var type:String;

	/**
	 *	A list of RGB colors for the fill.
	 */
	public var colors:Array;

	/**
	 *	A list of alpha transparency values associated with the
	 *	<code>colors</code> property. Valid values are between 0 and 100.
	 */
	public var alphas:Array;

	/**
	 *	The angle that the gradient is drawn in. This only applies to linear
	 *	gradients.
	 */
	public var angle:uint;
}
}
