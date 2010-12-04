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
public class LocalFile implements IFile
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
			_file = new File(file as String);
		}
		// Otherwise use the file reference given
		else if(file is File) {
			_file = file as File;
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
		if(!this.file.exists) {
			throw new IOError("File does not exist: " + this.file.nativePath);
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

	private var _file:File;

	/**
	 *	A reference to the underlying file on the file system.
	 */
	public function get file():File
	{
		return _file;
	}
	
	//---------------------------------
	//	Name
	//---------------------------------

	/**
	 *	The name of the file
	 */
	public function get name():String
	{
		return file.name;
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
		stream.open(file, FileMode.READ);
		stream.readBytes(bytes);
		stream.close();
		return bytes.toString();
	}
	
	//---------------------------------
	//	Parent
	//---------------------------------

	private var _parent:IFile;
	
	/**
	 *	@copy IFile#parent
	 */
	public function get parent():IFile
	{
		return _parent;
	}

	public function set parent(value:IFile):void
	{
		_parent = value;
	}


	//---------------------------------
	//	Root
	//---------------------------------

	/**
	 *	@copy IFile#root
	 */
	public function get root():IFile
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
	 *	@copy IFile#path
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
	 *	@copy IFile#isDirectory
	 */
	public function get isDirectory():Boolean
	{
		return file.isDirectory;
	}

	//---------------------------------
	//	Files
	//---------------------------------

	private var _files:Array;

	/**
	 *	@copy IFile#files
	 */
	public function get files():Array
	{
		var arr:Array = [];
		
		var nativeFiles:Array = file.getDirectoryListing();
		for each(var nativeFile:File in nativeFiles) {
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
	 *	@copy IFile#resolvePath()
	 */
	public function resolvePath(path:String):IFile
	{
		// Return null if no path is passed in
		if(path == null || path == "") {
			return null;
		}
		
		var nativeFile:File = file.resolvePath(path);
		
		// If file doesn't exist, return null
		if(!nativeFile.exists) {
			return null;
		}
		
		// Create file wrapper
		var localFile:LocalFile = new LocalFile(nativeFile);
		
		// Generate intermediate directories and link parents together
		var dir:LocalFile = this;
		var directoryNames:Array = path.split("/");
		directoryNames.pop();

		var current:String = file.nativePath;
		for each(var directoryName:String in directoryNames) {
			current += "/" + directoryName;
			var tmp:LocalFile = new LocalFile(current);
			tmp.parent = dir;
			dir = tmp;
		}

		localFile.parent = dir;
		
		return localFile;
	}
}
}
