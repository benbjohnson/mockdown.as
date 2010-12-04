package mockdown.parsers.block
{
import mockdown.components.Node;
import mockdown.components.Text;
import mockdown.core.Document;
import mockdown.errors.BlockParseError;
import mockdown.errors.ParseError;
import mockdown.managers.NodeManager;
import mockdown.parsers.property.IPropertyParser;
import mockdown.utils.FileUtil;

import flash.errors.IllegalOperationError;
import flash.filesystem.File; // TODO: Remove AIR dep

/**
 *	This class parses blocks into components.
 */
public class ComponentBlockParser implements IBlockParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function ComponentBlockParser()
	{
		super()
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  A list of parsers used to parse property values by data type.
	 */
	private var propertyParsers:Object = {};
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Property parser management
	//---------------------------------

	/**
	 *	Sets the property parser to use for a given data type.
	 *
	 *	@param type    The data type to use this property parser for.
	 *	@param parser  The property parser to use for this type.
	 */
	public function registerPropertyParser(type:String, parser:IPropertyParser):void
	{
		propertyParsers[type] = parser;
	}

	/**
	 *	Unsets the property parser to use for a given data type.
	 *
	 *	@param type    The data type to use this property parser for.
	 */
	public function unregisterPropertyParser(type:String):void
	{
		propertyParsers[type] == null;
		delete propertyParsers[type];
	}

	/**
	 *	Retrieves the property parser to use for a given data type.
	 *
	 *	@param type  The data type to use this property parser for.
	 * 
	 *	@return      The parser to use for this data type.
	 */
	public function getPropertyParser(type:String):IPropertyParser
	{
		return propertyParsers[type] as IPropertyParser;
	}


	//---------------------------------
	//	Parsing
	//---------------------------------

	/**
	 *	Parses a Mockdown file into a recursive node tree. This method will
	 *	search the registered node types as well as search the load path. Files
	 *	can be specified within folders by using the pipe ("|") separator.
	 *
	 *	@param name  The name of the node to parse.
	 *	
	 *	@return      A node object.
	 */
	public function parse(name:String):Node
	{
		// Throw error if name starts with a slash
		if(name == null || name == "") {
			throw new IllegalOperationError("The node name is required for parsing");
		}
		// Throw error if name starts with a slash
		if(name.indexOf("/") == 0 || name.indexOf("|") == 0) {
			throw new IllegalOperationError("You cannot a node name with '/' or '|'");
		}
		// Throw error if a double dot is found in the name
		if(name.indexOf("..") != -1) {
			throw new IllegalOperationError("You cannot specify '..' in a node name");
		}
		
		// Attempt to create a registered node type first
		var node:Node = nodeManager.create(name);
		
		// If type is not registered, search the load path
		if(!node) {
			// Change colons to directory seperators
			var filename:String = name.replace(/\|/g, "/");
			
			var extensions:Array = this.extensions.slice();
			extensions.unshift(null);

			for each(var path:String in paths) {
				for each(var extension:String in extensions) {
					extension = (extension ? "." + extension : "");
					
					var file:File = (new File(path)).resolvePath(filename + extension);
					if(file.exists) {
						var content:String;
						try {
							content = FileUtil.read(file);
						}
						catch(e:Error) {
							throw new ParseError("Cannot find component: " + name);
						}
						
						node = parseContent(content);
					
						// Assign a document to this node
						if(node) {
							node.document = new Document(file.nativePath);
						}
						
						return node;
					}
				}
			}
		}
		
		// Throw error if no node is found
		if(!node) {
			throw new ParseError("Cannot find node type in load path: " + name);
        }
		
		return node;
	}

	/**
	 *	Parses Mockdown content into a document object model.
	 *
	 *	@param content  The Mockdown content to parse.
	 *	
	 *	@return         A root document node.
	 */
	protected function parseContent(content:String):Node
	{
		// Validate content exists
		if(content == null) {
			throw new ParseError('Content is required for parsing');
        }

		// Return null if there is no content
		if(content.search(/\S/) == -1) {
			return null;
        }

		// Generate block tree and document
		var root:Block = preprocessor.createBlockTree(content);

		// Recursively parse from first child node
		var node:Node;
		if(root.children.length == 1) {		// TODO: Support pragmas
			node = parseBlock(root.children[0]);
		}

		return node;
	}


	//---------------------------------
	//	Node Parsing
	//---------------------------------

	/**
	 *	Parses block into a node.
	 *
	 *	@param block  The block to parse.
	 *	
	 *	@return       A node.
	 */
	protected function parseBlock(block:Block):Node
	{
		// If we don't receive a block then return null
		if(!block) {
			return null;
		}
		
		// Attempt to parse block
		var node:Node;
		var lexer:Lexer = new Lexer(block.content);

		if((node = parseComponentBlock(block, lexer)) != null) {}
		else if((node = parseMarkdownBlock(block, lexer)) != null) {}
		else {throw new BlockParseError(block, "Unable to parse block");}
		
		// Assign original block to node for parse error reporting.
		node.block = block;
		
		// Parse child blocks
		for each(var childBlock:Block in block.children) {
			node.addChild(parseBlock(childBlock));
		}
		
		return node
	}
	
	/**
	 *	Parses a component block into a node.
	 *
	 *	@param block  The block to parse.
	 *	
	 *	@return       A node.
	 */
	protected function parseComponentBlock(block:Block, lexer:Lexer):Node
	{
		var node:Node;
		
		// Parse block as component if it starts with a percent sign
		if(lexer.match("%")) {
			var name:String;
			if(!(name = lexer.match(/([^ ]+)\s*/))) {
				throw new BlockParseError(block, 'Missing component name');
			}
			
			// Create node by name
			node = nodeManager.create(name);

			// If node is not a system type then attempt to parse it.
			if(!node) {
				node = parse(name);
			}
			
			// Parse key/value pairs
			var data:Object = {};
			while(!lexer.eof) {
				var key:String = lexer.match(/[^: ]+/);

				if(key) {
					// If a colon is next, retrieve the value
					var value:String;
					if(lexer.match(/:/)) {
						// Attempt to match double-quoted value
						if((value = lexer.match(/"(.*?)(?<!\\)"/)) != null) {}
						else if(lexer.match('"')) {
							throw new BlockParseError(block, "Unmatched double-quote after '" + key + ":'");
						}
						// Attempt to match single-quoted value
						else if((value = lexer.match(/'(.*?)(?<!\\)'/)) != null) {}
						else if(lexer.match("'")) {
							throw new BlockParseError(block, "Unmatched single-quote after '" + key + ":'");
						}
						// Attempt to match unquoted value
						else if((value = lexer.match(/\S+/)) != null) {}
						else {
							throw new BlockParseError(block, "Missing value");
						}
					}
					// If no value is specified, treat it as true/false
					else {
						// A key with a bang prefixed is false
						if(key.indexOf("!") == 0) {
							key = key.substr(1);
							value = "false";
						}
						// A key alone is true.
						else {
							value = "true";
						}
					}
					
					// Assign to data object
					parseProperty(node, data, key, value);
				}
				else {
					// If we have no key and have not reached eof then we are
					// missing the key.
					if(!lexer.eof) {
						throw new BlockParseError(block, 'Missing key name');
					}
				}
				
				// Strip off trailing space
				lexer.match(/\s+/);
			}
			
			// Assign values to properties
			for(key in data) {
				node[key] = data[key];
			}
		}
		
		return node;
	}


	/**
	 *	Parses a key/value pair and assigns the value to a property on the
	 *	data object.
	 *
	 *	@param node      The node instance being parsed.
	 *	@param data      The data object.
	 *	@param property  The name of the property.
	 *	@param value     The string value.
	 */
	protected function parseProperty(node:Node, data:Object,
									 property:String, value:String):void
	{   
		// Retrieve type information for node
		//var type:Type = Type.forInstance(node);
		
		// TODO: Verify property exists & retrieve meta data
		// TODO: Select property parser based on data type
		// TODO: Parse and assign value
	}

	/**
	 *	Parses a markdown block into a text node.
	 *
	 *	@param block  The block to parse.
	 *	
	 *	@return       A text node.
	 */
	protected function parseMarkdownBlock(block:Block, lexer:Lexer):Node
	{
		// Remove spans of whitespace
		var content:String = block.content;
		content = content.replace(/\s+/smg, " ");
		
		// Create node
		var node:Text = new Text();
		node.content = content;
		
		return node;
	}
}
}
