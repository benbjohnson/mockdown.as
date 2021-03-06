package mockdown.components.loaders
{
import mockdown.components.BaseComponent;
import mockdown.components.parsers.ComponentParser;
import mockdown.components.parsers.DefaultComponentParser;
import mockdown.errors.LibraryNotFoundError;
import mockdown.filesystem.File;

import flash.errors.IllegalOperationError;

/**
 *	This class loads components from mockdown files found within the load path.
 */
public class FileComponentLoader extends BaseComponentLoader
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function FileComponentLoader(parent:ComponentLoader=null)
	{
		super(parent);
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The component parser.
	 */
	public var parser:ComponentParser = new DefaultComponentParser();

	/**
	 *	The load path for finding component file definitions.
	 */
	public var paths:Array = [];

	/**
	 *	A list of extensions to append to the component name when searching.
	 */
	public var extensions:Array = ["mkd", "mkx"];

	/**
	 *	The library path for the current project.
	 */
	public var libraryPath:File;

	/**
	 *	The base directory for all system libraries.
	 */
	public var systemLibraryPath:File;
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Find
	//---------------------------------

	/**
	 *	@copy ComponentLoader#find()
	 */
	override public function find(name:String):*
	{
		// Search parent loaders first
		var type:* = super.find(name);
		if(type != null) {
			return type;
		}

		// Otherwise attempt to search the file paths
		var filename:String = name.replace(":", "/");

		// Setup load paths
		var paths:Array = this.paths.slice();
		if(libraryPath) {
			paths.push(libraryPath);
		}
		
		// Search load path to find a file with the given name.
		for each(var path:File in paths) {
			var file:File = path.resolvePath(name);
			
			// Attempt multiple extensions
			if(!file) {
				for each(var extension:String in extensions) {
					file = path.resolvePath(name + "." + extension);
					if(file) {
						break;
					}
				}
			}
			
			if(file) {
				// Throw an error if we retrieve a directory
				if(file.isDirectory) {
					throw new IllegalOperationError("File is a directory: " + name);
				}
				// Otherwise parse the file
				else {
					// Create a new loader that points to the file's directory
					var loader:FileComponentLoader = clone();
					loader.paths = [file.parent];

					// Parse file into component definition
					parser.loader = loader;
					return parser.parse(file.content);
				}
			}
		}
		
		return null;
	}


	/**
	 *	@copy ComponentLoader#addLibrary()
	 */
	override public function addLibrary(name:String):void
	{
		// Throw error if no name is passed in
		if(name == null || name == "") {
			throw new ArgumentError("Library name is required");
		}
		// Throw error if a system library path is not defined
		if(!systemLibraryPath) {
			throw new IllegalOperationError("System library path has not been defined for this loader");
		}
		// Do not allow parent file access when loading libraries
		if(name.indexOf("..") != -1) {
			throw new IllegalOperationError("Library name cannot contain: '..'");
		}
		
		// Attempt to find component library in system path
		var path:File = systemLibraryPath.resolvePath(name);
		
		// Throw error if path doesn't exist
		if(!path) {
			throw new LibraryNotFoundError(name, "Library not found: " + name);
		}
		
		// Append library to paths
		paths.push(path);
	}
	
	/**
	 *	Creates a copy of this component loader.
	 */
	public function clone():FileComponentLoader
	{
		var loader:FileComponentLoader = new FileComponentLoader(parent);
		loader.libraryPath       = libraryPath;
		loader.systemLibraryPath = systemLibraryPath;
		return loader;
	}
}
}
