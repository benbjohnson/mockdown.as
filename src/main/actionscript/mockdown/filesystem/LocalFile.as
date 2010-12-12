package mockdown.filesystem
{
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.errors.IllegalOperationError;
import flash.errors.IOError;
import flash.utils.ByteArray;

/**
 *	This class represents a file or directory that exists on the file system.
 *	This class requires Adobe AIR so it is not included in non-AIR binaries.
 */
public class LocalFile extends Object implements mockdown.filesystem.File
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *
	 *	@param file  The reference or path of the file on the local
	 *	             filesystem.
	 */
	public function LocalFile(file:Object)
	{
		super();
		
		// Create a file reference if using a path
		if(file is String) {
			_nativeFile = new flash.filesystem.File(file as String);
		}
		// Otherwise use the file reference given
		else if(file is flash.filesystem.File) {
			_nativeFile = file as flash.filesystem.File;
		}
		// Throw an error when file is null
		else if(file == null) {
			throw new ArgumentError("File reference or full path cannot be null")
		}
		// Throw an error if it's some other type of object.
		else {
			throw new ArgumentError("File reference or full path is required")
		}
		

		// Throw error if file does not exist
		if(!this.nativeFile.exists) {
			throw new IOError("File does not exist: " + this.nativeFile.nativePath);
		}
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	File
	//---------------------------------

	private var _nativeFile:flash.filesystem.File;

	/**
	 *	A reference to the underlying file on the file system.
	 */
	public function get nativeFile():flash.filesystem.File
	{
		return _nativeFile;
	}

	/**
	 *	The native path to the file on the file system.
	 */
	public function get nativePath():String
	{
		return nativeFile.nativePath;
	}
	
	//---------------------------------
	//	Name
	//---------------------------------

	/**
	 *	The name of the file
	 */
	public function get name():String
	{
		return nativeFile.name;
	}
	
	//---------------------------------
	//	Content
	//---------------------------------

	/**
	 *	The contents of the file.
	 */
	public function get content():String
	{
		var bytes:ByteArray = new ByteArray();
		var stream:FileStream = new FileStream();
		stream.open(nativeFile, FileMode.READ);
		stream.readBytes(bytes);
		stream.close();
		return bytes.toString();
	}
	
	//---------------------------------
	//	Parent
	//---------------------------------

	private var _parent:mockdown.filesystem.File;
	
	/**
	 *	@copy File#parent
	 */
	public function get parent():mockdown.filesystem.File
	{
		return _parent;
	}

	public function set parent(value:mockdown.filesystem.File):void
	{
		_parent = value;
	}


	//---------------------------------
	//	Root
	//---------------------------------

	/**
	 *	@copy File#root
	 */
	public function get root():File
	{
		if(parent) {
			return parent.root;
		}
		else {
			return this;
		}
	}


	//---------------------------------
	//	Path
	//---------------------------------

	/**
	 *	@copy File#path
	 */
	public function get path():String
	{
		if(parent) {
			return parent.path + "/" + name;
		}
		else {
			return "";
		}
	}

	//---------------------------------
	//	Is directory
	//---------------------------------

	/**
	 *	@copy File#isDirectory
	 */
	public function get isDirectory():Boolean
	{
		return nativeFile.isDirectory;
	}

	//---------------------------------
	//	Files
	//---------------------------------

	private var _files:Array;

	/**
	 *	@copy File#files
	 */
	public function get files():Array
	{
		var arr:Array = [];
		
		var nativeFiles:Array = nativeFile.getDirectoryListing();
		for each(var nativeFile:flash.filesystem.File in nativeFiles) {
	    	var f:LocalFile = new LocalFile(nativeFile.nativePath);
			f.parent = this;
			arr.push(f);
		}

		return arr;
	}



	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	File management
	//---------------------------------

	/**
	 *	@copy File#resolvePath()
	 */
	public function resolvePath(path:String):mockdown.filesystem.File
	{
		// Return null if no path is passed in
		if(path == null || path == "") {
			return null;
		}
		
		var resolvedNativeFile:flash.filesystem.File = nativeFile.resolvePath(path);
		
		// If file doesn't exist, return null
		if(!resolvedNativeFile.exists) {
			return null;
		}
		
		// Create file wrapper
		var resolvedFile:LocalFile = new LocalFile(resolvedNativeFile);
		
		// Generate intermediate directories and link parents together
		var dir:LocalFile = this;
		var directoryNames:Array = path.split("/");
		directoryNames.pop();

		var current:String = nativePath;
		for each(var directoryName:String in directoryNames) {
			current += "/" + directoryName;
			var tmp:LocalFile = new LocalFile(current);
			tmp.parent = dir;
			dir = tmp;
		}

		resolvedFile.parent = dir;
		
		return resolvedFile;
	}


	//---------------------------------
	//	To string
	//---------------------------------
	
	/** @private */
	public function toString():String
	{
		return "[LocalFile " + nativePath + "]";
	}
}
}
