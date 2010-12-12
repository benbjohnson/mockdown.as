package mockdown.filesystem
{
import flash.errors.IllegalOperationError;

/**
 *	This class represents a file or directory that exists in-memory. This can
 *	be used as a simulated file system for system components or for remote 
 *	file systems that have been loaded in their entirety.
 */
public class MemoryFile implements File
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *
	 *	@param name     The name of the file.
	 *	@param content  The contents of the file. If null, this file is a
	 *	                directory.
	 */
	public function MemoryFile(name:String=null, content:String=null)
	{
		super();
		
		// Do not allow name to have a file separator.
		if(name && name.indexOf("/") != -1) {
			throw new ArgumentError("File name cannot contain a slash character: " + name);
		}
		
		_name = name;
		_content = content;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Name
	//---------------------------------

	private var _name:String;

	/**
	 *	The name of the file
	 */
	public function get name():String
	{
		return _name;
	}
	
	//---------------------------------
	//	Content
	//---------------------------------

	private var _content:String;

	/**
	 *	The contents of the file.
	 */
	public function get content():String
	{
		return _content;
	}
	
	//---------------------------------
	//	Parent
	//---------------------------------

	private var _parent:File;
	
	/**
	 *	@copy File#parent
	 */
	public function get parent():File
	{
		return _parent;
	}

	public function set parent(value:File):void
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
		else if(name != null) {
			return name;
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
		return (content == null);
	}

	//---------------------------------
	//	Files
	//---------------------------------

	private var _files:Array = [];
	
	/**
	 *	@copy File#files
	 */
	public function get files():Array
	{
		return _files.slice();
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
	public function resolvePath(path:String):File
	{
		if(!path) {
			return null;
		}
		
		// Find the next file in the path
		var dirs:Array = path.split("/");
		var filename:String = dirs.shift();
		
		for each(var file:File in _files) {
			if(file.name == filename) {
				// If we are at the end of the directories then return the file
				if(dirs.length == 0) {
					return file;
				}
				// Otherwise continue recursively searching
				else {
					return file.resolvePath(dirs.join("/"));
				}
			}
		}
		
		return null;
	}

	/**
	 *	Adds a file to a relative path.
	 *
	 *	@param file  The file to add.
	 */
	public function add(file:MemoryFile):void
	{
		// Validate file exists
		if(!file) {
			throw new ArgumentError("File is required");
		}
		// Validate file name
		if(!file.name || file.name == "") {
			throw new ArgumentError("Cannot add unnamed file");
		}

		// Add file if it doesn't already exist
		if(_files.indexOf(file) == -1) {
			file.parent = this;
			_files.push(file);
		}
	}

	/**
	 *	Removes a file within this directory.
	 *
	 *	@param file  The file to remove.
	 */
	public function remove(file:MemoryFile):void
	{
		var index:int = _files.indexOf(file);
		if(index != -1) {
			file.parent = null;
			_files.splice(index, 1);
		}
	}
}
}
