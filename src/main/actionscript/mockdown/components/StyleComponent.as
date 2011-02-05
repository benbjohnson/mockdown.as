package mockdown.components
{
import mockdown.display.Color;
import mockdown.display.RenderObject;
import mockdown.display.Fill;
import mockdown.display.GradientFill;
import mockdown.display.Stroke;
import mockdown.display.SolidColorFill;
import mockdown.geom.Rectangle;
import mockdown.utils.ParameterUtil;

import flash.errors.IllegalOperationError;

/**
 *	This class represents a component that has the ability to display a border
 *	and background.
 */
public dynamic class StyleComponent extends Component
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function StyleComponent()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

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
			
			// Append alpha if it's less than 100%
			if(borderAlpha < 100) {
				value += " " + borderAlpha + "%";
			}
		}
		
		return value;
	}

	public function set border(value:String):void
	{
		ParameterUtil.parse(this, value, "borderThickness:length:1 borderColor:color:1 borderAlpha:percent:1");
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
		ParameterUtil.parse(this, value, "backgroundColors:color:* backgroundAlphas:percent:* backgroundGradientType:string:1 backgroundAngle:int:1");

		// Throw error if too many alphas
		if(backgroundAlphas.length > backgroundColors.length) {
			throw new ArgumentError("Too many alpha values specified");
		}

		// Default alphas
		while(backgroundAlphas.length < backgroundColors.length) {
			backgroundAlphas.push(100);
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
