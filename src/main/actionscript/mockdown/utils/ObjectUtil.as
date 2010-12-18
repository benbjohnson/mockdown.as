package mockdown.utils
{
import flash.utils.ByteArray;

/**
 * 	This class contains static methods for working with objects.
 */		
public class ObjectUtil
{
	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Makes a deep copy of an object.
	 * 
	 *	@param obj  The object to copy.
	 *
	 *	@returns    A copy of the object.
	 */			
	static public function copy(obj:Object):Object
	{
		var buffer:ByteArray = new ByteArray();
		buffer.writeObject(obj);
		buffer.position = 0;
		return buffer.readObject();
	}
}
}