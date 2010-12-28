package mockdown.components
{
import mockdown.display.Color;
import mockdown.display.RenderObject;
import mockdown.display.Fill;
import mockdown.display.Stroke;
import mockdown.display.SolidColorFill;
import mockdown.geom.Rectangle;

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


	//---------------------------------
	//	Border
	//---------------------------------

	/**
	 *	The border style. This is a string composed of thickness, color, alpha.
	 */
	public function get border():String
	{
		var value:String = "";

		// Generate string only if color is set
		if(!isNaN(borderColor)) {
			value = borderThickness + "px #" + Color.toHex(borderColor);
			
			// Append alpha is it's less than 100%
			if(borderAlpha < 100) {
				value += " " + borderAlpha + "%";
			}
		}
		
		return value;
	}

	public function set border(value:String):void
	{
		// Reset values if blank value is passed in
		if(!value || value == "") {
			borderThickness = borderAlpha = borderColor = NaN;
		}
		// Otherwise parse string
		else {
			var match:Array = value.match(/^(\d+)px #([A-Fa-f0-9]{6})(?: (\d+)%)?$/);
			if(!match) {
				throw new ArgumentError("Invalid border format");
			}
			else {
				borderThickness = parseInt(match[1]);
				borderColor = parseInt(match[2], 16);
				borderAlpha = (match[3] ? parseInt(match[3]) : 100);
			}
		}
	}

	[Property(type="uint")]
	/**
	 *	The color of the border.
	 */
	public var borderColor:Number;

	/**
	 *	The alpha transparency of the border.
	 */
	public var borderAlpha:uint = 100;

	/**
	 *	The thickness of the border, in pixels.
	 */
	public var borderThickness:uint = 1;


	//---------------------------------
	//	Background
	//---------------------------------

	/**
	 *	The background style. This is a string composed of color and alpha.
	 */
	public function get background():String
	{
		var value:String = "";

		// Generate string only if color is set
		if(!isNaN(backgroundColor)) {
			value = "#" + Color.toHex(backgroundColor);
			
			// Append alpha is it's less than 100%
			if(backgroundAlpha < 100) {
				value += " " + backgroundAlpha + "%";
			}
		}
		
		return value;
	}

	public function set background(value:String):void
	{
		// Reset values if blank value is passed in
		if(!value || value == "") {
			backgroundAlpha = backgroundColor = NaN;
		}
		// Otherwise parse string
		else {
			var match:Array = value.match(/^#([A-Fa-f0-9]{6})(?: (\d+)%)?$/);
			if(!match) {
				throw new ArgumentError("Invalid background format");
			}
			else {
				backgroundColor = parseInt(match[1], 16);
				backgroundAlpha = (match[2] ? parseInt(match[2]) : 100);
			}
		}
	}


	[Property(type="uint")]
	/**
	 *	The color of the background.
	 */
	public var backgroundColor:Number;

	/**
	 *	The alpha transparency of the background.
	 */
	public var backgroundAlpha:uint = 100;


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
		for each(var child:Component in _children) {
			child.layout();
		}
	}


	//---------------------------------
	//	Rendering
	//---------------------------------

	/** @private */
	override public function render(display:RenderObject):void
	{
		super.render(display);
		
		// Create stroke and fill
		var stroke:Stroke;
		var fill:Fill;
		if(!isNaN(borderColor)) {
			stroke = new Stroke(borderColor, borderAlpha, borderThickness);
		}
		if(!isNaN(backgroundColor)) {
			fill = new SolidColorFill(backgroundColor, backgroundAlpha);
		}

		// Draw the rectangle on the display
		display.drawRect(new Rectangle(0, 0, pixelWidth, pixelHeight), stroke, fill);
	}
}
}
