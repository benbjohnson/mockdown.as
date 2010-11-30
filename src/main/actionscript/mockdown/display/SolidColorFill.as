package mockdown.display
{
/**
 *	This class is used for defining a polygon fill that uses a single color.
 *
 *	@see IRenderObject
 */
public class SolidColorFill
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function SolidColorFill():void
	{
		super();
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
