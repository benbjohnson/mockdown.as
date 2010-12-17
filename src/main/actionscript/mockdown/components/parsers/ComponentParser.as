package mockdown.components.parsers
{
import mockdown.components.Component;
import mockdown.components.ComponentDescriptor;
import mockdown.components.loaders.ComponentLoader;
import mockdown.errors.BlockParseError;
import mockdown.parsers.Block;
import mockdown.parsers.Lexer;
import mockdown.parsers.WhitespaceParser;

/**
 *	This class represents a parser for a Mockdown document.
 */
public class ComponentParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function ComponentParser()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The loader used retrieve component definitions.
	 */
	public var loader:ComponentLoader;
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Parsing
	//---------------------------------

	/**
	 *	Parses Mockdown formatted content into a component descriptor.
	 *
	 *	@param content  The content to parse.
	 *
	 *	@return         The component defined by the content.
	 */
	public function parse(content:String):ComponentDescriptor
	{
		var root:Block = createBlockTree(content);
		
		// Parse pragmas at the root
		// parsePragmas(root);
		
		// Find first component definition and parse descriptors from there
		var blocks:Array = root.children.filter(function(item:Block,...args):Boolean{return item.content.charAt(0) == "%"});
		
		// Parse root component
		if(blocks.length == 1) {
			return parseComponent(blocks[0] as Block);
		}
		// Throw error if we have no root component
		else if(blocks.length == 0) {
			throw new BlockParseError(root, 'A root component is required');
		}
		// Throw error if we have more than one root component
		else {
			throw new BlockParseError(root, 'Only one root component is allowed');
		}

		return null;
	}
	
	/**
	 *	Parses mockdown content into a tree of blocks.
	 */
	private function createBlockTree(content:String):Block
	{
		var parser:WhitespaceParser = new WhitespaceParser();
		return parser.parse(content);
	}
	

	//---------------------------------
	//	Components
	//---------------------------------

	private function parseComponent(block:Block):ComponentDescriptor
	{
		var lexer:Lexer = new Lexer(block.content);
		var descriptor:ComponentDescriptor = new ComponentDescriptor();

		// Determine the component
		var name:String = lexer.match(/^%(\w+)\s*/);
		if(!name) {
			throw new BlockParseError(block, "Expected component name");
		}

		// Find component
		descriptor.parent = loader.find(name);
		if(!descriptor.parent) {
			throw new BlockParseError(block, "Component not found: " + name);
		}
		
		// Parse property values
		parseComponentProperties(block, descriptor, lexer);
		
		// Parse child components
		for each(var childBlock:Block in block.children) {
			var childDescriptor:ComponentDescriptor = parseComponent(childBlock);
			descriptor.children.push(childDescriptor);
		}
		
		return descriptor;
	}

	private function parseComponentProperties(block:Block, descriptor:ComponentDescriptor, lexer:Lexer):void
	{
		// Parse key/value pairs
		while(!lexer.eof) {
			var key:String = lexer.match(/^\w+/);
			if(key) {
				// If a colon is next, retrieve the value
				var value:String;
				if(!lexer.match(/=/)) {
					throw new BlockParseError(block, "Expected '='");
				}
				
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
				
				// Assign to data object
				descriptor.values[key] = value;
			}
			else {
				// If we have no key and have not reached eof then we are
				// missing the key.
				if(!lexer.eof) {
					throw new BlockParseError(block, "Expected: key name");
				}
			}
			
			// Strip off trailing space
			lexer.match(/\s+/);
		}
	}
}
}
