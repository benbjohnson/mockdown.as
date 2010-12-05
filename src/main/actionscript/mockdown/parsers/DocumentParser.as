package mockdown.parsers
{
import mockdown.parsers.block.IBlockParser;
import mockdown.parsers.property.IPropertyParser;

/**
 *	This class represents a parser for a Mockdown documents.
 */
public class DocumentParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function DocumentParser()
	{
		super();
		nodeManager = new NodeManager();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	A list of supported extensions to use.
	 */
	public var extensions:Array = ["mkd", "mkx"];
	
	
	//---------------------------------
	//	Load paths
	//---------------------------------

	private var _paths:Array = [];
	
	/**
	 *  A list of paths to search while creating nodes by name.
	 */
	public function get paths():Array
	{
		return _paths.slice();
	}
	
	//---------------------------------
	//	Block parsers
	//---------------------------------

	private var _blockParsers:Array = [];
	
	/**
	 *  A list of parsers used to parse blocks into nodes.
	 */
	public function get blockParsers():Array
	{
		return _blockParsers.slice();
	}
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Node management
	//---------------------------------

	/**
	 *	A factory method for creating nodes by name. Registered system classes
	 *	are attempted first and then documents are searched within the load 
	 *	path.
	 *
	 *	@param name  The name of the node to create.
	 */
	public function createNode(name:String):Node
	{
		var node:Node
		
		// Find system node class and return an instance
		node = nodeManager.create(name);
		
		// If not found, search the load path for a document to parse
		if(!node) {
			var file:IFile = resolvePath(path, filename);
			if(file) {
				node = parse(file);
			
				// Assign a document to this node
				if(node) {
					node.document = new Document(file);
				}
				
				return node;
			}
		}
		
		return node;
	}
	

	//---------------------------------
	//	Block parser management
	//---------------------------------

	/**
	 *	Adds a parser to use while parsing blocks. Parsers are attempted one
	 *	after another in the order they are added until one of them
	 *	successfully returns a node while parsing.
	 *
	 *	@param parser  The block parser to add.
	 */
	public function addBlockParser(parser:IBlockParser):void
	{
		_blockParsers.push(parser);
	}

	/**
	 *	Removes a parser from the list of block parsers.
	 *
	 *	@param parser  The block parser to remove.
	 */
	public function removeBlockParser(parser:IBlockParser):void
	{
		var index:int = _blockParsers.indexOf(parser);
		if(index != -1) {
			_blockParsers.splice(index, 1);
		}
	}


	//---------------------------------
	//	File management
	//---------------------------------

	/**
	 *	Searches the load path and attempts to load all files with the given
	 *	filename that have valid extensions.
	 */
	public function resolvePath(filename:String):IFile
	{
		// Change colons to directory seperators
		filename = filename.replace(/:/g, "/");
		
		// Create list of extensions to try
		var extensions:Array = this.extensions.slice();
		extensions.unshift(null);

		// Iterate over load paths
		for each(var path:String in paths) {
			for each(var extension:String in extensions) {
				extension = (extension ? "." + extension : "");
				
				var file:IFile = (new IFile(path)).resolvePath(filename + extension);
				if(file) {
					return file;
				}
			}
		}
		
		return null;
	}
}
}
