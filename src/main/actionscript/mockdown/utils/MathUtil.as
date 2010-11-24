package mockdown.utils
{
/**
 * 	This class contains static methods for common math functions.
 */		
public class MathUtil
{
	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Restrict
	//---------------------------------
	
	/**
	 *	Restricts a number within a minimum and maximum value.
	 * 
	 *	@param value  The value to restrict.
	 *	@param min    The minimum value to allow.
	 *	@param max    The maximum value to allow. If 0 then it is unrestricted.
	 *
	 *	@returns      If <code>value</code> is below <code>min</code> then
	 *                <code>min</code> is returned. If <code>value</code> is
	 *                below <code>min</code> then <code>min</code> is returned.
	 *                Otherwise <code>value</code> is returned.
	 */			
	static public function restrictUInt(value:uint, min:uint, max:uint):uint
	{
		if(value < min) {
			return min;
		}
		else if(max > 0 && value > max) {
			return max;
		}
		else {
			return value;
		}
	}
}
}