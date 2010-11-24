package mockdown.utils
{
/**
 * 	This class contains static methods for manipulating strings.
 */		
public class StringUtil
{
	//--------------------------------------------------------------------------
	//
	//	Static Constants
	//
	//--------------------------------------------------------------------------
	
	static private var WHITESPACE:Object = {9:true, 10:true, 13:true, 32:true};
	

	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Trim
	//---------------------------------
	
	/**
	 *	Strips leading and trailing whitespace.
	 * 
	 *	@param str  The string to strip whitespace from.
	 *
	 *	@returns    A trimmed string.
	 */			
	static public function trim(str:String):String
	{
		return StringUtil.ltrim(StringUtil.rtrim(str));
	}

	/**
	 *	Strips leading whitespace.
	 * 
	 *	@param str  The string to strip whitespace from.
	 *
	 *	@returns    A left trimmed string.
	 */			
	static public function ltrim(str:String):String
	{
		var n:int = str.length;
		for(var i:int=0; i<n; i++) {
			if(!WHITESPACE[str.charCodeAt(i)]) {
				return str.substring(i);
			}
		}
		return "";
	}

	/**
	 *	Strips trailing whitespace.
	 * 
	 *	@param str  The string to strip whitespace from.
	 *
	 *	@returns    A right trimmed string.
	 */			
	static public function rtrim(str:String):String
	{
		var n:int = str.length;
		for(var i:int=n; i>0; i--) {
			if(!WHITESPACE[str.charCodeAt(i-1)]) {
				return str.substring(0, i);
			}
		}
		return "";
	}


	//---------------------------------
	//	Parsing
	//---------------------------------
	
	/**
	 *	Parses a string into an integer.
	 * 
	 *	@param str  The string to parse.
	 *
	 *	@returns    The parsed integer.
	 */			
	static public function parseNumber(str:String):Number
	{
		var match:Array;
		if(str && (match = str.match(/^-?\d+$/))) {
			return parseInt(str);
		}
		else if(str && (match = str.match(/^-?\d+(?:\.\d+)?$/))) {
			return parseFloat(str);
		}
		else {
			return NaN;
		}
	}

	/**
	 *	Parses a string into a percentage.
	 * 
	 *	@param str  The string to parse.
	 *
	 *	@returns    The parsed integer percentage.
	 */			
	static public function parsePercentage(str:String):Number
	{
		var match:Array;
		if(str && (match = str.match(/^(-?\d+)%$/))) {
			return parseInt(match[1]);
		}
		else if(str && (match = str.match(/^(-?\d+(?:\.\d+)?)%$/))) {
			return parseFloat(match[1]);
		}
		else {
			return NaN;
		}
	}
	
	/**
	 *	Checks if the given string is a null or blank string.
	 * 
	 *	@param str  The string to check.
	 *
	 *	@return     True if empty. Otherwise false.
	 */			
	static public function isEmpty(str:String):Boolean
	{
		return (str == null || str == "");
	}
}
}