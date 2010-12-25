package mockdown.components
{
import mockdown.display.RenderObject;
import mockdown.display.Stroke;
import mockdown.display.SolidColorFill;
import mockdown.geom.Rectangle;
import mockdown.utils.MathUtil;

import flash.errors.IllegalOperationError;

/**
 *	This class represents a visual component on a mockup.
 */
public dynamic class Component
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Component()
	{
		super();
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Parent
	//---------------------------------
	
	/**
	 *	The parent component in the display tree hierarchy.
	 */
	public var parent:Component;

	//---------------------------------
	//	Children
	//---------------------------------
	
	protected var _children:Array = [];
	
	/**
	 *	A list of child components attached to this component in the display
	 *	tree.
	 */
	public function get children():Array
	{
		return _children.slice();
	}
	

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
	 *	The top offset from the parent component.
	 */
	public var top:Number;

	/**
	 *	The bottom offset from the parent component.
	 */
	public var bottom:Number;

	/**
	 *	The left offset from the parent component.
	 */
	public var left:Number;

	/**
	 *	The right offset from the parent component.
	 */
	public var right:Number;
	
	
	//---------------------------------
	//	Dimension
	//---------------------------------

	/**
	 *	The explicit width of the component, in pixels.
	 */
	public var pixelWidth:uint;
	
	/**
	 *	The explicit height of the component, in pixels.
	 */
	public var pixelHeight:uint;

	/**
	 *	The width of the component.
	 */
	public var width:Number;
	
	/**
	 *	The height of the component.
	 */
	public var height:Number;

	/**
	 *	The percentage width of the component.
	 */
	public var percentWidth:Number;
	
	/**
	 *	The percentage height of the component.
	 */
	public var percentHeight:Number;

	/**
	 *	The minimium width of the component.
	 */
	public var minWidth:Number;
	
	/**
	 *	The minimum height of the component.
	 */
	public var minHeight:Number;

	/**
	 *	The maximum width of the component.
	 */
	public var maxWidth:Number;
	
	/**
	 *	The maximum height of the component.
	 */
	public var maxHeight:Number;


	//---------------------------------
	//	Padding
	//---------------------------------

	/**
	 *	The amount to pad children from the top of the container.
	 */
	public var paddingTop:uint;

	/**
	 *	The amount to pad children from the bottom of the container.
	 */
	public var paddingBottom:uint;

	/**
	 *	The amount to pad children from the left of the container.
	 */
	public var paddingLeft:uint;

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
	//	Children
	//---------------------------------
	
	/**
	 *	Appends a component to the list of children.
	 *	
	 *	@param child  The component to append.
	 */
	public function addChild(child:Component):void
	{
		if(child != null && _children.indexOf(child) == -1) {
			child.parent = this;
			_children.push(child);
		}
	}
	
	/**
	 *	Removes a component from the list of children.
	 *	
	 *	@param child  The component to remove.
	 */
	public function removeChild(child:Component):void
	{
		if(child != null && _children.indexOf(child) != -1) {
			child.parent = null;
			_children.splice(_children.indexOf(child), 1);
		}
	}

	/**
	 *	Removes all children from a component.
	 */
	public function removeAllChildren():void
	{
		var children:Array = this.children;
		for each(var child:Component in children) {
			removeChild(child);
		}
	}


	//---------------------------------
	//	Measurement
	//---------------------------------
	
	/**
	 *	Resets the pixel dimensions of the component and its children.
	 */
	public function reset():void
	{
		// Reset dimensions
		pixelWidth  = 0;
		pixelHeight = 0;
		
		// Reset child pixel dimensions
		for each(var child:Component in _children) {
			child.reset();
		}
	}

	/**
	 *	Determines the final pixel dimensions for the component. This is
	 *	calculated for all components once before rendering to screen.
	 */
	public function measure():void
	{
		measureExplicit();
		measureChildren();
		measureImplicit();
	}

	/**
	 *	Attempts to explicitly measures the component.
	 */
	protected function measureExplicit():void
	{
		var num:Number;
		
		// Keep dimension within min/max range
		if(!isNaN(width)) {
			pixelWidth  = MathUtil.restrict(width, minWidth, maxWidth);
		}
		if(!isNaN(height)) {
			pixelHeight = MathUtil.restrict(height, minHeight, maxHeight);
		}
	}
	
	/**
	 *	Calls <code>measure()</code> on each visual child.
	 */
	protected function measureChildren():void
	{
		for each(var child:Component in _children) {
			child.measure();
		}
	}
	
	/**
	 *	Attempts to measure the component as the largest dimensions of its children.
	 */
	protected function measureImplicit():void
	{
		var child:Component;
		
		// Measure width
		if(isNaN(width)) {
			// Sum child widths
			var pixelWidth:uint = 0;
			for each(child in _children) {
				pixelWidth = Math.max(pixelWidth, child.pixelWidth);
			}
			
			// Add padding
			pixelWidth = pixelWidth + paddingLeft + paddingRight;
			
			// Restrict width to min/max
			this.pixelWidth = MathUtil.restrict(pixelWidth, minWidth, maxWidth);
		}
		
		// Measure height
		if(isNaN(height)) {
			// Sum child heights
			var pixelHeight:uint = 0;
			for each(child in _children) {
				pixelHeight = Math.max(pixelHeight, child.pixelHeight);
			}

			// Add padding
			pixelHeight = pixelHeight + paddingTop + paddingBottom;
			
			// Restrict height to min/max
			this.pixelHeight = MathUtil.restrict(pixelHeight, minHeight, maxHeight);
		}
	}


	//---------------------------------
	//	Layout
	//---------------------------------

	/**
	 *	Lays out the component and its children after the size of all componets
	 *	has been computed.
	 */
	public function layout():void
	{
	}


	//---------------------------------
	//	Rendering
	//---------------------------------

	/**
	 *	Renders the component visually to the screen.
	 */
	public function render(display:RenderObject):void
	{
		display.move(x, y);
		display.resize(pixelWidth, pixelHeight);
		
		display.drawRect(new Rectangle(0, 0, pixelWidth, pixelHeight), Stroke.BLACK, new SolidColorFill(0, 20));
		display.drawLine(0, 0, pixelWidth, pixelHeight, Stroke.BLACK);
		display.drawLine(0, pixelHeight, pixelWidth, 0, Stroke.BLACK);
	}
}
}
