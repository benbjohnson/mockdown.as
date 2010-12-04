package mockdown.filesystem
{
/**
 *	This interface defines methods for accessing file-based content. It allows
 *	the parser to work with tree-based file systems abstractly so that the
 *	file system can be in-memory, disk-based or remote.
 */
public interface IFile
{
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	                                                                           
	/**
	 *	The name of the file.
	 */
	function get name():String;

	/**
	 *	The path from the root directory of this file system.
	 */
	function get path():String;

	/**
	 *	The files that are contained within this directory.
	 */
	function get files():Array;

	/**
	 *	A flag stating if the file is a directory.
	 */
	function get isDirectory():Boolean;

	/**
	 *	The directory that contains this file.
	 */
	function get parent():IFile;
	function set parent(value:IFile):void;

	/**
	 *	The root directory of the file system.
	 */
	function get root():IFile;

	/**
	 *	The contents of the file.
	 */
	function get content():String;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	                                                                           
	/**
	 *	Retrieves a file relative to this file location.
	 *
	 *	@param path  The relative path to search for.
	 *
	 *	@return      A file object if this is a directory and the relative file
	 *				 exists. If this is a file or the relative file doesn't
	 *				 exist then this method returns null.
	 */
	function resolvePath(path:String):IFile;
}
}
