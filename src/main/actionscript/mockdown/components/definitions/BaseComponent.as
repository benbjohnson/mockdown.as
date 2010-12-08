package mockdown.components.definitions
{
import mockdown.display.IRenderObject;
import mockdown.utils.MathUtil;

import flash.errors.IllegalOperationError;

/**
 *	This class uses ActionScript to define the 
 */
public class BaseComponent
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function BaseComponent()
	{
		// throw new IllegalOperationError("This class is a component definition and cannot be instantiated");
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Position
	//---------------------------------
	
	[Property]
	/**
	 *	The absolute position from the left of the parent container.
	 */
	public var x:int;
	
	[Property]
	/**
	 *	The absolute position from the top of the parent container.
	 */
	public var y:int;


	//---------------------------------
	//	Position
	//---------------------------------

	[Property]
	/**
	 *	The top offset from the parent node.
	 */
	public var top:int;

	[Property]
	/**
	 *	The bottom offset from the parent node.
	 */
	public var bottom:int;

	[Property]
	/**
	 *	The left offset from the parent node.
	 */
	public var left:int;

	[Property]
	/**
	 *	The right offset from the parent node.
	 */
	public var right:int;
	
	
	//---------------------------------
	//	Dimension
	//---------------------------------

	[Property]
	/**
	 *	The explicit width of the node, in pixels.
	 */
	public var pixelWidth:uint;
	
	[Property]
	/**
	 *	The explicit height of the node, in pixels.
	 */
	public var pixelHeight:uint;

	[Property(type="uint")]
	/**
	 *	The width of the node.
	 */
	public var width:*;
	
	[Property(type="uint")]
	/**
	 *	The height of the node.
	 */
	public var height:*;

	[Property]
	/**
	 *	The minimium width of the node.
	 */
	public var minWidth:uint;
	
	[Property]
	/**
	 *	The minimum height of the node.
	 */
	public var minHeight:uint;

	[Property]
	/**
	 *	The maximum width of the node.
	 */
	public var maxWidth:uint;
	
	[Property]
	/**
	 *	The maximum height of the node.
	 */
	public var maxHeight:uint;


	//---------------------------------
	//	Padding
	//---------------------------------

	[Property]
	/**
	 *	The amount to pad children from the top of the container.
	 */
	public var paddingTop:uint;

	[Property]
	/**
	 *	The amount to pad children from the bottom of the container.
	 */
	public var paddingBottom:uint;

	[Property]
	/**
	 *	The amount to pad children from the left of the container.
	 */
	public var paddingLeft:uint;

	[Property]
	/**
	 *	The amount to pad children from the right of the container.
	 */
	public var paddingRight:uint;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Measurement
	//---------------------------------
	
	[Function]
	/**
	 *	Determines the final pixel dimensions for the node. This is calculated
	 *	for all nodes once before rendering to screen.
	 */
	public var measure:Function = function():void
	{
		// Reset width and height
		pixelWidth  = 0;
		pixelHeight = 0;
		
		trace("node: " + this);
		measureExplicit();
		// measureChildren();
		// measureImplicit();
	};

	[Function]
	/**
	 *	Attempts to explicitly measures the node.
	 */
	public var measureExplicit:Function = function():void
	{
		var num:Number;
		
		// Keep dimension within min/max range
		if(width != null) {
			pixelWidth  = MathUtil.restrictUInt(width, minWidth, maxWidth);
		}
		if(height != null) {
			pixelHeight = MathUtil.restrictUInt(height, minHeight, maxHeight);
		}
	};
	
	//[Function]
	/**
	 *	Calls <code>measure()</code> on each visual child.
	 */
	/*
	public var measureChildren = function():void
	{
		for each(var child:Node in children) {
			child.measure();
		}
	}
	*/
	
	// [Function]
	/**
	 *	Attempts to measure the node as the largest dimensions of its children.
	 */
	/*
	public var measureImplicit = function():void
	{
		var child:Node;
		
		// Measure width
		if(StringUtil.isEmpty(width)) {
			// Sum child widths
			var pixelWidth:uint = 0;
			for each(child in children) {
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
	*/

	//---------------------------------
	//	Rendering
	//---------------------------------

	[Function]
	/**
	 *	Renders the node visually to the screen.
	 */
	public var render:Function = function(display:IRenderObject):void
	{
		/*
		display.move(x, y);
		display.resize(pixelWidth, pixelHeight);
		
		display.drawRect(new Rectangle(0, 0, pixelWidth, pixelHeight), Stroke.BLACK, new SolidColorFill(0, 20));
		display.drawLine(0, 0, pixelWidth, pixelHeight, Stroke.BLACK);
		display.drawLine(0, pixelHeight, pixelWidth, 0, Stroke.BLACK);
		*/
	};
}
}
