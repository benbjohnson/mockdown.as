package mockdown.components
{
import mockdown.display.IRenderObject;
import mockdown.utils.MathUtil;
import mockdown.utils.StringUtil;

/**
 *	This class represents a node that will be displayed on-screen.
 */
public class VisualNode extends Node
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function VisualNode()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Pixel dimensions
	//---------------------------------
	
	/**
	 *	The absolute position from the left of the parent container.
	 */
	public var x:int;
	
	/**
	 *	The absolute position from the top of the parent container.
	 */
	public var y:int;

	/**
	 *	The explicit width of the node in pixels.
	 */
	public var pixelWidth:uint;

	/**
	 *	The explicit height of the node in pixels.
	 */
	public var pixelHeight:uint;

	/**
	 *	The explicit minimum width of the node in pixels.
	 */
	public var pixelMinWidth:uint;

	/**
	 *	The explicit minimum height of the node in pixels.
	 */
	public var pixelMinHeight:uint;

	/**
	 *	The explicit maximum width of the node in pixels.
	 */
	public var pixelMaxWidth:uint;

	/**
	 *	The explicit maximum height of the node in pixels.
	 */
	public var pixelMaxHeight:uint;


	//---------------------------------
	//	Explicit dimensions
	//---------------------------------
	
	/**
	 *	The explicit width set for the node.
	 */
	public function get explicitWidth():Number
	{
		return StringUtil.parseNumber(width);
	}
	
	/**
	 *	The explicit height set for the node.
	 */
	public function get explicitHeight():Number
	{
		return StringUtil.parseNumber(height);
	}
	
	
	//---------------------------------
	//	Percent dimensions
	//---------------------------------
	
	/**
	 *	The percentage width set for the node.
	 */
	public function get percentWidth():Number
	{
		return StringUtil.parsePercentage(width);
	}
	
	/**
	 *	The percentage height set for the node.
	 */
	public function get percentHeight():Number
	{
		return StringUtil.parsePercentage(height);
	}
	

	//---------------------------------
	//	Position
	//---------------------------------

	/**
	 *	The top offset from the parent node.
	 */
	public var top:String;

	/**
	 *	The bottom offset from the parent node.
	 */
	public var bottom:String;

	/**
	 *	The left offset from the parent node.
	 */
	public var left:String;

	/**
	 *	The right offset from the parent node.
	 */
	public var right:String;
	
	
	//---------------------------------
	//	Dimension
	//---------------------------------

	/**
	 *	The width of the node.
	 */
	public var width:String;
	
	/**
	 *	The height of the node.
	 */
	public var height:String;

	/**
	 *	The minimium width of the node.
	 */
	public var minWidth:String;
	
	/**
	 *	The minimum height of the node.
	 */
	public var minHeight:String;

	/**
	 *	The maximum width of the node.
	 */
	public var maxWidth:String;
	
	/**
	 *	The maximum height of the node.
	 */
	public var maxHeight:String;


	//---------------------------------
	//	Padding
	//---------------------------------

	/**
	 *	The amount to pad children from the top of the container.
	 */
	public var paddingTop:String;

	/**
	 *	The amount to pad children from the bottom of the container.
	 */
	public var paddingBottom:String;

	/**
	 *	The amount to pad children from the left of the container.
	 */
	public var paddingLeft:String;

	/**
	 *	The amount to pad children from the right of the container.
	 */
	public var paddingRight:String;


	//---------------------------------
	//	Pixel padding
	//---------------------------------
	
	/**
	 *	The top padding, in pixels.
	 */
	public var pixelPaddingTop:uint;

	/**
	 *	The bottom padding, in pixels.
	 */
	public var pixelPaddingBottom:uint;

	/**
	 *	The left padding, in pixels.
	 */
	public var pixelPaddingLeft:uint;

	/**
	 *	The right padding, in pixels.
	 */
	public var pixelPaddingRight:uint;



	//---------------------------------
	//	Visual children
	//---------------------------------

	/**
	 *	A list of visual children attached to the node.
	 */
	public function get visualChildren():Array
	{
		return children.filter(
			function(item:Object,...args):Boolean{
				return item is VisualNode;
			}
		);
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Measurement
	//---------------------------------
	
	/**
	 *	Determines the final pixel dimensions for the node. This is calculated
	 *	for all nodes once before rendering to screen.
	 */
	public function measure():void
	{
		// Reset width and height
		pixelWidth  = 0;
		pixelHeight = 0;
		
		measureExplicit();
		measureChildren();
		measureImplicit();
	}

	/**
	 *	Attempts to explicitly measures the node.
	 */
	protected function measureExplicit():void
	{
		var num:Number;

		// Parse padding
		pixelPaddingTop    = StringUtil.parseNumber(paddingTop);
		pixelPaddingBottom = StringUtil.parseNumber(paddingBottom);
		pixelPaddingLeft   = StringUtil.parseNumber(paddingLeft);
		pixelPaddingRight  = StringUtil.parseNumber(paddingRight);

		// Parse min/max dimensions
		pixelMinWidth  = StringUtil.parseNumber(minWidth);
		pixelMinHeight = StringUtil.parseNumber(minHeight);
		pixelMaxWidth  = StringUtil.parseNumber(maxWidth);
		pixelMaxHeight = StringUtil.parseNumber(maxHeight);
		
		// Set explicit width
		if(!isNaN(num = StringUtil.parseNumber(width))) {
			pixelWidth = MathUtil.restrictUInt(num, pixelMinWidth, pixelMaxWidth);
		}

		// Set explicit height
		if(!isNaN(num = StringUtil.parseNumber(height))) {
			pixelHeight = MathUtil.restrictUInt(num, pixelMinHeight, pixelMaxHeight);
		}
	}
	
	/**
	 *	Calls <code>measure()</code> on each visual child.
	 */
	protected function measureChildren():void
	{
		for each(var child:VisualNode in visualChildren) {
			child.measure();
		}
	}
	
	/**
	 *	Attempts to measure the node as the largest dimensions of its children.
	 */
	protected function measureImplicit():void
	{
		var child:VisualNode;
		
		// Measure width
		if(StringUtil.isEmpty(width)) {
			// Sum child widths
			var pixelWidth:uint = 0;
			for each(child in visualChildren) {
				pixelWidth = Math.max(pixelWidth, child.pixelWidth);
			}
			
			// Add padding
			pixelWidth = pixelWidth + pixelPaddingLeft + pixelPaddingRight;
			
			// Restrict width to min/max
			this.pixelWidth = MathUtil.restrictUInt(pixelWidth, pixelMinWidth, pixelMaxWidth);
		}
		
		// Measure height
		if(StringUtil.isEmpty(height)) {
			// Sum child heights
			var pixelHeight:uint = 0;
			for each(child in visualChildren) {
				pixelHeight = Math.max(pixelHeight, child.pixelHeight);
			}

			// Add padding
			pixelHeight = pixelHeight + pixelPaddingTop + pixelPaddingBottom;
			
			// Restrict height to min/max
			this.pixelHeight = MathUtil.restrictUInt(pixelHeight, pixelMinHeight, pixelMaxHeight);
		}
	}
	

	//---------------------------------
	//	Layout
	//---------------------------------
	
	/**
	 *	Layouts the children of the node.
	 */
	public function layout():void
	{
		// This is overridden by the subclass.
	}

	//---------------------------------
	//	Rendering
	//---------------------------------

	/**
	 *	Renders the node visually to the screen
	 */
	public function render(display:IRenderObject):void
	{
		// This is overridden by the subclass.
	}
}
}
