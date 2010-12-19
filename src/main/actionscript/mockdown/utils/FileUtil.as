package mockdown.utils
{
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

/**
 *	This class provides helper methods to read and write files.
 */
public class FileUtil
{
	//-------------------------------------------------------------------------
	//
	//  Static methods
	//
	//-------------------------------------------------------------------------

	//---------------------------------
	//	String-based files
	//---------------------------------

	/**
	 *	Reads the entire contents of the file as a string.
	 *	
	 *	@param file  The file to read.
	 *	
	 *	@return      A string representing the contents of the file.
	 */
	static public function read(file:File):String
	{
		// If file does not exist, return null
		if(!file || !file.exists) {
			return null;
		}
		
		// Otherwise read file
		var bytes:ByteArray = new ByteArray();
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.READ);
		stream.readBytes(bytes);
		stream.close();
		return bytes.toString();
	}

	/**
	 *	Writes a string to file.
	 *	
	 *	@param file  The file to write to.
	 *	@param data  The string to write to file.
	 */
	static public function write(file:File, data:String):void
	{
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		stream.writeUTFBytes(data);
		stream.close();
	}

	/**
	 *	Deletes a file.
	 *	
	 *	@param file  The file to delete.
	 */
	static public function deleteFile(file:File):void
	{
		try {
			file.deleteFile();
		} catch(e:Error) {
			trace("Error removing file: " + e.toString());
		}
	}
}
}