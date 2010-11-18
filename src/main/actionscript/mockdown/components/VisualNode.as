package mockdown.components
{
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


	//---------------------------------
	//	Pixel width
	//---------------------------------

	private var _pixelWidth:Number;
	
	/**
	 *	The explicit width of the node in pixels. This is determined by the
	 *	<code>width</code> property.
	 */
	public function get pixelWidth():Number
	{
		return _pixelWidth;
	}

	public function set pixelWidth(value:Number):void
	{
		_pixelWidth = Math.max(0, Math.round(value));
	}


	//---------------------------------
	//	Pixel height
	//---------------------------------

	private var _pixelHeight:Number;
	
	/**
	 *	The explicit height of the node in pixels. This is determined by the
	 *	<code>height</code> property.
	 */
	public function get pixelHeight():Number
	{
		return _pixelHeight;
	}

	public function set pixelHeight(value:Number):void
	{
		_pixelHeight = Math.max(0, Math.round(value));
	}


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
		// Set width and height if explicitly set
		if(isNaN(pixelWidth)) {
			pixelWidth  = StringUtil.parseNumber(width);
		}
		if(isNaN(pixelHeight)) {
			pixelHeight = StringUtil.parseNumber(height);
		}
	}


	//---------------------------------
	//	Rendering
	//---------------------------------

	/**
	 *	Renders the node visually to the screen
	 */
	public function render():void
	{
		// This is overridden by the subclass.
	}
}
}
