package mockdown.components
{
import mockdown.display.Color;
import mockdown.display.RenderObject;
import mockdown.display.Fill;
import mockdown.display.GradientFill;
import mockdown.display.Stroke;
import mockdown.display.SolidColorFill;
import mockdown.geom.Rectangle;

import flash.errors.IllegalOperationError;

/**
 *	This class represents a container that lays out its children.
 */
public dynamic class LayoutContainer extends Component
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function LayoutContainer()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Gap
	//---------------------------------

	/**
	 *	The gap between children, in pixels.
	 */
	public var gap:int;
	
	
	//---------------------------------
	//	Alignment
	//---------------------------------

	/**
	 *	The horizontal alignment of the column children. Possible values are
	 *	<code>left<code>, <code>center<code> or <code>right</code>.
	 */
	public var align:String;

	/**
	 *	The vertical alignment of the column children. Possible values are
	 *	<code>top<code>, <code>middle<code> or <code>bottom</code>.
	 */
	public var valign:String;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Layout
	//---------------------------------

	/** @private */
	override public function layout():void
	{
		layoutChildren();
	}

	/**
	 *	Calls layout for each child.
	 */
	protected function layoutChildren():void
	{
		for each(var child:BaseComponent in _children) {
			child.layout();
		}
	}
}
}
