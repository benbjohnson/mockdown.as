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

	private const FORMAT_BORDER:String = "borderThickness:length:1 borderColor:color:1 borderAlpha:percent:1";

	/**
	 *	The border style.
	 */
	public function get border():String
	{
		return ParameterUtil.format(this, FORMAT_BORDER);
	}

	public function set border(value:String):void
	{
		ParameterUtil.parse(this, value, FORMAT_BORDER);
	}


	//---------------------------------
	//	Border Thickness
	//---------------------------------

	private var _borderThickness:uint;
	/**
	 *	The border thickness.
	 */
	public function get borderThickness():uint
	{
		return _borderThickness;
	}

	public function set borderThickness(value:uint):void
	{
		_borderThickness = value;
		borderTopThickness    = value;
		borderBottomThickness = value;
		borderLeftThickness   = value;
		borderRightThickness  = value;
	}


	//---------------------------------
	//	Border Color
	//---------------------------------

	private var _borderColor:Number;
	
	/**
	 *	The border color.
	 */
	public function get borderColor():Number
	{
		return _borderColor;
	}

	public function set borderColor(value:Number):void
	{
		_borderColor = value;
		borderTopColor    = value;
		borderBottomColor = value;
		borderLeftColor   = value;
		borderRightColor  = value;
	}


	//---------------------------------
	//	Border Alpha
	//---------------------------------

	private var _borderAlpha:uint;
	
	/**
	 *	The border alpha.
	 */
	public function get borderAlpha():uint
	{
		return _borderAlpha;
	}

	public function set borderAlpha(value:uint):void
	{
		_borderAlpha = value;
		borderTopAlpha    = value;
		borderBottomAlpha = value;
		borderLeftAlpha   = value;
		borderRightAlpha  = value;
	}


	//---------------------------------
	//	Border - Top
	//---------------------------------

	private const FORMAT_BORDER_TOP:String = "borderTopThickness:length:1 borderTopColor:color:1 borderTopAlpha:percent:1";

	/**
	 *	The top border style.
	 */
	public function get borderTop():String
	{
		return ParameterUtil.format(this, FORMAT_BORDER_TOP);
	}

	public function set borderTop(value:String):void
	{
		ParameterUtil.parse(this, value, FORMAT_BORDER_TOP);
	}

	[Property(type="uint")]
	/**
	 *	The color of the top border.
	 */
	public var borderTopColor:Number;

	/**
	 *	The alpha transparency of the top border.
	 */
	public var borderTopAlpha:uint = 100;

	/**
	 *	The thickness of the top border, in pixels.
	 */
	public var borderTopThickness:uint = 0;


	//---------------------------------
	//	Border - Bottom
	//---------------------------------

	private const FORMAT_BORDER_BOTTOM:String = "borderBottomThickness:length:1 borderBottomColor:color:1 borderBottomAlpha:percent:1";

	/**
	 *	The bottom border style.
	 */
	public function get borderBottom():String
	{
		return ParameterUtil.format(this, FORMAT_BORDER_BOTTOM);
	}

	public function set borderBottom(value:String):void
	{
		ParameterUtil.parse(this, value, FORMAT_BORDER_BOTTOM);
	}

	[Property(type="uint")]
	/**
	 *	The color of the Bottom border.
	 */
	public var borderBottomColor:Number;

	/**
	 *	The alpha transparency of the bottom border.
	 */
	public var borderBottomAlpha:uint = 100;

	/**
	 *	The thickness of the bottom border, in pixels.
	 */
	public var borderBottomThickness:uint = 0;


	//---------------------------------
	//	Border - Left
	//---------------------------------

	private const FORMAT_BORDER_LEFT:String = "borderLeftThickness:length:1 borderLeftColor:color:1 borderLeftAlpha:percent:1";

	/**
	 *	The left border style.
	 */
	public function get borderLeft():String
	{
		return ParameterUtil.format(this, FORMAT_BORDER_LEFT);
	}

	public function set borderLeft(value:String):void
	{
		ParameterUtil.parse(this, value, FORMAT_BORDER_LEFT);
	}

	[Property(type="uint")]
	/**
	 *	The color of the left border.
	 */
	public var borderLeftColor:Number;

	/**
	 *	The alpha transparency of the left border.
	 */
	public var borderLeftAlpha:uint = 100;

	/**
	 *	The thickness of the left border, in pixels.
	 */
	public var borderLeftThickness:uint = 0;


	//---------------------------------
	//	Border - Right
	//---------------------------------

	private const FORMAT_BORDER_RIGHT:String = "borderRightThickness:length:1 borderRightColor:color:1 borderRightAlpha:percent:1";

	/**
	 *	The right border style.
	 */
	public function get borderRight():String
	{
		return ParameterUtil.format(this, FORMAT_BORDER_RIGHT);
	}

	public function set borderRight(value:String):void
	{
		ParameterUtil.parse(this, value, FORMAT_BORDER_RIGHT);
	}

	[Property(type="uint")]
	/**
	 *	The color of the right border.
	 */
	public var borderRightColor:Number;

	/**
	 *	The alpha transparency of the right border.
	 */
	public var borderRightAlpha:uint = 100;

	/**
	 *	The thickness of the right border, in pixels.
	 */
	public var borderRightThickness:uint = 0;



	//---------------------------------
	//	Border Radius
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
		var fill:Fill;
		if(backgroundColors.length == 1) {
			fill = new SolidColorFill(backgroundColor, backgroundAlpha);
		}
		else if(backgroundColors.length > 1) {
			fill = new GradientFill(backgroundGradientType, backgroundColors, backgroundAlphas, backgroundAngle);
		}

		// Draw the rectangle on the display
		display.drawBorderedBackground(this, fill);
	}
}
}
