package mockdown.utils
{
import flash.errors.IllegalOperationError;

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
}
}