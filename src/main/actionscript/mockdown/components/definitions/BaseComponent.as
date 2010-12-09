package mockdown.components.definitions
{
import mockdown.components.Node;
import mockdown.display.IRenderObject;
import mockdown.utils.MathUtil;

import flash.errors.IllegalOperationError;

/**
 *	This class uses ActionScript to define the 
 */
public dynamic class BaseComponent
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
	
	/**
	 *	The absolute position from the left of the parent container.
	 */
	public var x:int;
	
	/**
	 *	The absolute position from the top of the parent container.
	 */
	public var y:int;


	//---------------------------------
	//	Position
	//---------------------------------

	/**
	 *	The top offset from the parent node.
	 */
	public var top:int;

	/**
	 *	The bottom offset from the parent node.
	 */
	public var bottom:int;

	/**
	 *	The left offset from the parent node.
	 */
	public var left:int;

	/**
	 *	The right offset from the parent node.
	 */
	public var right:int;
	
	
	//---------------------------------
	//	Dimension
	//---------------------------------

	[Property(nullable="false")]
	/**
	 *	The explicit width of the node, in pixels.
	 */
	public var pixelWidth:uint;
	
	[Property(nullable="false")]
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

	/**
	 *	The minimium width of the node.
	 */
	public var minWidth:uint;
	
	/**
	 *	The minimum height of the node.
	 */
	public var minHeight:uint;

	/**
	 *	The maximum width of the node.
	 */
	public var maxWidth:uint;
	
	/**
	 *	The maximum height of the node.
	 */
	public var maxHeight:uint;


	//---------------------------------
	//	Padding
	//---------------------------------

	[Property(nullable="false")]
	/**
	 *	The amount to pad children from the top of the container.
	 */
	public var paddingTop:uint;

	[Property(nullable="false")]
	/**
	 *	The amount to pad children from the bottom of the container.
	 */
	public var paddingBottom:uint;

	[Property(nullable="false")]
	/**
	 *	The amount to pad children from the left of the container.
	 */
	public var paddingLeft:uint;

	[Property(nullable="false")]
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
	
	/**
	 *	Determines the final pixel dimensions for the node. This is calculated
	 *	for all nodes once before rendering to screen.
	 */
	public var measure:Function = function():void
	{
		// Reset width and height
		pixelWidth  = 0;
		pixelHeight = 0;
		
		measureExplicit();
		measureChildren();
		measureImplicit();
	};

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
	
	/**
	 *	Calls <code>measure()</code> on each visual child.
	 */
	public var measureChildren:Function = function():void
	{
		for each(var child:Node in this.children) {
			child.measure();
		}
	};
	
	/**
	 *	Attempts to measure the node as the largest dimensions of its children.
	 */
	public var measureImplicit:Function = function():void
	{
		var child:Node;
		
		// Measure width
		if(width == null) {
			// Sum child widths
			var pixelWidth:uint = 0;
			for each(child in this.children) {
				pixelWidth = Math.max(pixelWidth, child.pixelWidth);
			}
			
			// Add padding
			pixelWidth = pixelWidth + paddingLeft + paddingRight;
			
			// Restrict width to min/max
			this.pixelWidth = MathUtil.restrictUInt(pixelWidth, minWidth, maxWidth);
		}
		
		// Measure height
		if(height == null) {
			// Sum child heights
			var pixelHeight:uint = 0;
			for each(child in this.children) {
				pixelHeight = Math.max(pixelHeight, child.pixelHeight);
			}

			// Add padding
			pixelHeight = pixelHeight + paddingTop + paddingBottom;
			
			// Restrict height to min/max
			this.pixelHeight = MathUtil.restrictUInt(pixelHeight, minHeight, maxHeight);
		}
	};

	//---------------------------------
	//	Rendering
	//---------------------------------

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
