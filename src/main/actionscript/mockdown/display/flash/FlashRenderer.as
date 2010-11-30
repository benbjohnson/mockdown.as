package mockdown.display.flash
{
import mockdown.display.Renderer;

/**
 *	This class renders a node into Flash output.
 *
 *	@see FlashRenderObject
 */
public class FlashRenderer extends Renderer
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function FlashRenderer()
	{
		super();
		renderObjectClass = FlashRenderObject;
	}
}
}
