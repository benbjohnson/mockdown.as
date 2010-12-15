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
	 *	@param max    The maximum value to allow.
	 *
	 *	@returns      If <code>value</code> is below <code>min</code> then
	 *                <code>min</code> is returned. If <code>value</code> is
	 *                below <code>min</code> then <code>min</code> is returned.
	 *                Otherwise <code>value</code> is returned.
	 */			
	static public function restrict(value:Number, min:Number, max:Number):Number
	{
		if(!isNaN(min) && value < min) {
			return min;
		}
		else if(!isNaN(max) && value > max) {
			return max;
		}
		else {
			return value;
		}
	}
}
}