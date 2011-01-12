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

	//---------------------------------
	//	Border styles
	//---------------------------------

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
	//	Border
	//---------------------------------

	/**
	 *	The radius for the four corners of the border.
	 */
	public function get borderRadius():String
	{
		var values:Array = [borderTopLeftRadius, borderTopRightRadius,
							borderBottomRightRadius, borderBottomLeftRadius];
		
		return values.join(" ");
	}

	public function set borderRadius(value:String):void
	{
		var values:Array = (value ? value.split(/\s+/) : [0]);
		borderTopLeftRadius  = (values.length > 0 ? parseInt(values[0]) : 0);
		borderTopRightRadius = (values.length > 1 ? parseInt(values[1]) : borderTopLeftRadius);
		borderBottomRightRadius = (values.length > 2 ? parseInt(values[2]) : borderTopLeftRadius);
		borderBottomLeftRadius = (values.length > 3 ? parseInt(values[3]) : borderTopRightRadius);
	}

	//---------------------------------
	//	Border radius styles
	//---------------------------------

	/**
	 *	The border radius of the top left corner.
	 */
	public var borderTopLeftRadius:uint = 0;

	/**
	 *	The border radius of the top right corner.
	 */
	public var borderTopRightRadius:uint = 0;

	/**
	 *	The border radius of the bottom left corner.
	 */
	public var borderBottomLeftRadius:uint = 0;

	/**
	 *	The border radius of the bottom right corner.
	 */
	public var borderBottomRightRadius:uint = 0;


	//---------------------------------
	//	Background
	//---------------------------------

	/**
	 *	The background style. This style is composed of:
	 *
	 *	<pre>
	 *	COLORS ALPHAS ANGLE GRADIENT-TYPE
	 *	</pre>
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
			// Split into colors and alphas sections
			var args:Array   = value.split(/\s+/);
			var colors:Array = args[0].split(/,/);
			var alphas:Array = (args.length > 1 ? args[1].split(/,/) : []);
			var gradientType:String = (args.length > 2 ? args[2] : "linear");
			var angle:uint   = (args.length > 3 ? parseInt(args[3]) : 0);
			
			// Parse colors and alphas
			colors = colors.map(function(item:String,...args):uint{return Color.fromHex(item)});
			alphas = alphas.map(function(item:String,...args):uint{return parseInt(item)});

			// Default alphas to 100% if not specifid
			if(alphas.length == 0) {
				colors.forEach(function(item:Object,...args):void{alphas.push(100)});
			}
			// Throw error if we don't have the same number of colors and alphas
			else if(colors.length != alphas.length) {
				throw new IllegalOperationError("The number of colors and alphas must match");
			}
			
			// Default alphas if missing
			for(var i:int=0; i<colors.length; i++) {
				if(alphas.length == i) {
					alphas.push(100);
				}
				else if(isNaN(alphas[i])) {
					alphas[i] = 100;
				}
			}

			// Assign values
			backgroundColors = colors;
			backgroundAlphas = alphas;
			backgroundGradientType = gradientType;
			backgroundAngle  = angle;
		}
	}


	//---------------------------------
	//	Solid background styles
	//---------------------------------
	
	/**
	 *	The color of the background.
	 */
	public function get backgroundColor():uint
	{
		return backgroundColors[0];
	}

	public function set backgroundColor(value:uint):void
	{
		backgroundColors = [value];
	}


	/**
	 *	The alpha transparency of the background.
	 */
	public function get backgroundAlpha():uint
	{
		return backgroundAlphas[0];
	}

	public function set backgroundAlpha(value:uint):void
	{
		backgroundAlphas = [value];
	}


	//---------------------------------
	//	Gradient background styles
	//---------------------------------
	
	[Property(itemType="uint")]
	/**
	 *	A list of colors to use for the background. If only one is specified,
	 *	the background is a solid color. If multiple are specified then a
	 *	gradient background is produced.
	 */
	public var backgroundColors:Array = [];

	[Property(itemType="uint")]
	/**
	 *	The alpha transparency of the background.
	 */
	public var backgroundAlphas:Array = [100];

	/**
	 *	The type of gradient to use for the background. Possible values are
	 *	"linear" or "radial".
	 */
	public var backgroundGradientType:String = "linear";

	/**
	 *	The angle of the background gradient.
	 */
	public var backgroundAngle:uint = 0;


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
		if(backgroundColors.length == 1) {
			fill = new SolidColorFill(backgroundColor, backgroundAlpha);
		}
		else if(backgroundColors.length > 1) {
			fill = new GradientFill(backgroundGradientType, backgroundColors, backgroundAlphas, backgroundAngle);
		}

		// Draw the rectangle on the display
		var rect:Rectangle = new Rectangle(0, 0, pixelWidth, pixelHeight)
		rect.borderTopLeftRadius     = borderTopLeftRadius;
		rect.borderTopRightRadius    = borderTopRightRadius;
		rect.borderBottomLeftRadius  = borderBottomLeftRadius;
		rect.borderBottomRightRadius = borderBottomRightRadius;
		display.drawRect(rect, stroke, fill);
	}
}
}
