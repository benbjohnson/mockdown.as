package mockdown.display
{
import flash.errors.IllegalOperationError;

/**
 *	This class provides helper functions for working with color values.
 */
public class Color
{
	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Converts an RGB value to a hexadecimal color string.
	 * 
	 *	@param value  The RGB value.
	 *
	 *	@returns      A hexadecimal string.
	 */			
	static public function toHex(value:uint):String
	{
		var str:String = (value & 0xFFFFFF).toString(16).toUpperCase();
		while(str.length < 6) {
			str = "0" + str;
		}
		return str;
	}

	/**
	 *	Converts a hexadecimal color string to an RGB value.
	 * 
	 *	@param value  A hexadecimal string.
	 *
	 *	@returns      The RGB value.
	 */			
	static public function fromHex(value:String):uint
	{
		if(value) {
			// Remove starting hash
			if(value.charAt(0) == "#") {
				value = value.substr(1);
			}
			
			// Parse as a hex string
			return parseInt(value, 16);
		}
		else {
			return 0;
		}
	}


	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Color():void
	{
		throw new IllegalOperationError("Cannot instantiate this class");
	}
}
}
