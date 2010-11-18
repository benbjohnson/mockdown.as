package mockdown.components
{
import mockdown.utils.StringUtil;

/**
 *	This class represents the base class for the container classes.
 */
public class Container extends VisualNode
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Container()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Padding (top)
	//---------------------------------

	private var _paddingTop:String;
	
	/**
	 *	The amount to pad children from the top of the container.
	 */
	public function get paddingTop():String
	{
		return _paddingTop;
	}

	public function set paddingTop(value:String):void
	{
		_paddingTop = value;
		_pixelPaddingTop = NaN;
	}


	//---------------------------------
	//	Padding (bottom)
	//---------------------------------

	private var _paddingBottom:String;
	
	/**
	 *	The amount to pad children from the bottom of the container.
	 */
	public function get paddingBottom():String
	{
		return _paddingBottom;
	}

	public function set paddingBottom(value:String):void
	{
		_paddingBottom = value;
		_pixelPaddingBottom = NaN;
	}


	//---------------------------------
	//	Padding (Left)
	//---------------------------------

	private var _paddingLeft:String;
	
	/**
	 *	The amount to pad children from the left of the container.
	 */
	public function get paddingLeft():String
	{
		return _paddingLeft;
	}

	public function set paddingLeft(value:String):void
	{
		_paddingLeft = value;
		_pixelPaddingLeft = NaN;
	}


	//---------------------------------
	//	Padding (Right)
	//---------------------------------

	private var _paddingRight:String;
	
	/**
	 *	The amount to pad children from the right of the container.
	 */
	public function get paddingRight():String
	{
		return _paddingRight;
	}

	public function set paddingRight(value:String):void
	{
		_paddingRight = value;
		_pixelPaddingRight = NaN;
	}


	//---------------------------------
	//	Pixel padding (Top)
	//---------------------------------
	
	private var _pixelPaddingTop:Number;
	
	/**
	 *	The top padding, in pixels.
	 */
	public function get pixelPaddingTop():Number
	{
		if(isNaN(_pixelPaddingTop)) {
			if(isNaN(_pixelPaddingTop = StringUtil.parseNumber(paddingTop))) {
				_pixelPaddingTop = 0;
			}
			_pixelPaddingTop = Math.round(_pixelPaddingTop);
		}
		
		return _pixelPaddingTop;
	}


	//---------------------------------
	//	Pixel padding (Bottom)
	//---------------------------------
	
	private var _pixelPaddingBottom:Number;
	
	/**
	 *	The bottom padding, in pixels.
	 */
	public function get pixelPaddingBottom():Number
	{
		if(isNaN(_pixelPaddingBottom)) {
			if(isNaN(_pixelPaddingBottom = StringUtil.parseNumber(paddingBottom))) {
				_pixelPaddingBottom = 0;
			}
			_pixelPaddingBottom = Math.round(_pixelPaddingBottom);
		}
		
		return _pixelPaddingBottom;
	}


	//---------------------------------
	//	Pixel padding (Left)
	//---------------------------------
	
	private var _pixelPaddingLeft:Number;
	
	/**
	 *	The left padding, in pixels.
	 */
	public function get pixelPaddingLeft():Number
	{
		if(isNaN(_pixelPaddingLeft)) {
			if(isNaN(_pixelPaddingLeft = StringUtil.parseNumber(paddingLeft))) {
				_pixelPaddingLeft = 0;
			}
			_pixelPaddingLeft = Math.round(_pixelPaddingLeft);
		}
		
		return _pixelPaddingLeft;
	}


	//---------------------------------
	//	Pixel padding (Right)
	//---------------------------------
	
	private var _pixelPaddingRight:Number;
	
	/**
	 *	The Right padding, in pixels.
	 */
	public function get pixelPaddingRight():Number
	{
		if(isNaN(_pixelPaddingRight)) {
			if(isNaN(_pixelPaddingRight = StringUtil.parseNumber(paddingRight))) {
				_pixelPaddingRight = 0;
			}
			_pixelPaddingRight = Math.round(_pixelPaddingRight);
		}
		
		return _pixelPaddingRight;
	}
}
}
