package mockdown.parsers
{
import mockdown.components.Node;
import mockdown.components.Text;
import mockdown.core.Document;
import mockdown.errors.BlockParseError;
import mockdown.errors.ParseError;
import mockdown.managers.NodeManager;
import mockdown.parsers.block.IBlockParser;
import mockdown.parsers.property.IPropertyParser;
import mockdown.utils.FileUtil;
import mockdown.utils.StringUtil;

import flash.errors.IllegalOperationError;
import flash.filesystem.File; // TODO: Remove AIR dep

/**
 *	This class represents a parser for a Mockdown file.
 */
public class MockdownParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function MockdownParser()
	{
		nodeManager = new NodeManager();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Manages the registration and creation of nodes by name.
	 */
	public var nodeManager:NodeManager;
	

	/**
	 *	The load path for finding file-based nodes by type.
	 */
	public var paths:Array = [];
	
	/**
	 *	A list of supported extensions to use.
	 */
	public var extensions:Array = ["mkd", "mkx"];
	
	
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
	//	Block preprocessing
	//---------------------------------

	/**
	 *	Parses a string into a tree of blocks which are grouped by indentation.
	 *
	 *	@param content - The string to parse.
	 *	
	 *	@return          A tree of blocks. Each block contains the unindented
	 *	                 content, line number and other parsing information.
	 */
	public function createBlockTree(content:String):Block
	{
		// Validate content exists
		if(content == null) {
			throw new ParseError('Content is required for parsing');
        }

		// Setup root & state
		var root:Block  = new Block(null, 0, 0)
		var stack:Array = [root];
		var lastBlock:Block = root;
		var multilineBlock:Block;

		// Loop over lines and group into blocks
		var lines:Array = content.split(/\n/);
		for(var i:int=0; i<lines.length; i++) {
			var lineNumber:int = i+1;
			var line:String = lines[i];

			// Skip line if blank
			if(line.search(/^\s*$/) == 0) {
				multilineBlock = null;
			}
			else {
				// Split of indentation and rest of line
				var match:Array = line.match(/^(\s*)(.+)$/);
				var indentation:String = match[1];
				line = StringUtil.trim(match[2]);
          
				// Throw error if indentation is wrong
				if(indentation.length % 2 != 0) {
					throw new ParseError('You cannot indent an odd number of spaces.', lineNumber)
				}
				// Throw error if tabs were used
				else if(indentation.search(/\t/) != -1) {
					throw new ParseError('You cannot use tabs for indentation.', lineNumber)
				}
          
				// Determine level by indentation
				var level:int = (indentation.length/2) + 1;
				var stackLevel:int = stack.length - 1;
          
				// Adjust stack if level we go down in levels
				if(level < stackLevel) {
					for(var x:int=0; x<(stackLevel-level); x++) {
						stack.pop();
					}
				}
				// Add last block to stack if level goes up by one
				else if(level == stackLevel+1) {
					stack.push(lastBlock)
				}
				// Throw error if we go up by more than one level
				else if(level > stackLevel+1) {
					throw new ParseError('You can not indent multiple levels between lines.', lineNumber)
				}
  
				// Clear multiline block when changing indentation
				if(level != stackLevel) {
					multilineBlock = null;
				}
          
				// If this line extends a multiline block, append the content
				if(multilineBlock && !isSingleLineBlock(line)) {
					multilineBlock.content += "\n" + line;
				}
				// Otherwise create a new block for this line
				else {
					var parent:Block = stack[stack.length-1];
					var block:Block = new Block(parent, level, lineNumber, line);
					parent.addChild(block);
					lastBlock = block;
					multilineBlock = (isSingleLineBlock(line) ? null : block);
				}
			}
		}
        
        return root;
	}

	/**
	 *	Determines if a block is a single line block. This is true if the
	 *	content of the line begins with an exclamation point or a percent sign.
	 *
	 *	@param content  The content of the line.
	 *
	 *	@return         A flag if the line should be a single line block.
	 */
	protected function isSingleLineBlock(content:String):Boolean
	{
		// TODO: Move this to the Block parsers
		return content.search(/^(%|!)/) == 0
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
		// Throw error if name is not passed in.
		if(name == null || name == "") {
			throw new ArgumentError("The node name is required for parsing");
		}
		// Throw error if name starts with a slash
		if(name.indexOf("/") == 0 || name.indexOf("|") == 0) {
			throw new ArgumentError("You cannot a node name with '/' or '|'");
		}
		// Throw error if a double dot is found in the name
		if(name.indexOf("..") != -1) {
			throw new ArgumentError("You cannot specify '..' in a node name");
		}
		
		// Attempt to create a registered node type first
		var node:Node = nodeManager.create(name);
		
		// If type is not registered, search the load path
		if(!node) {
			// Change colons to directory seperators
			var filename:String = name.replace(/:/g, "/");
			
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
		var root:Block = createBlockTree(content);

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
