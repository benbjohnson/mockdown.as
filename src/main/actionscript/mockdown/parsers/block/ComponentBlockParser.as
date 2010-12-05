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
		
		addPropertyParser(new StringPropertyParser());
		addPropertyParser(new NumberPropertyParser());
		addPropertyParser(new BooleanPropertyParser());
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Property parsers
	//---------------------------------

	private var _propertyParsers:Array = [];
	
	/**
	 *  A list of parsers used to parse property values.
	 */
	public function get propertyParsers():Array
	{
		return _propertyParsers.slice();
	}
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Property parser management
	//---------------------------------

	/**
	 *	Adds a property parser.
	 *
	 *	@param parser  The property parser.
	 */
	public function addPropertyParser(parser:IPropertyParser):void
	{
		if(propertyParsers.indexOf(parser) == -1) {
			propertyParsers.push(parser);
		}
	}

	/**
	 *	Removes a property parser.
	 *
	 *	@param parser  The property parser.
	 */
	public function removePropertyParser(parser:IPropertyParser):void
	{
		var index:int = propertyParsers.indexOf(parser);
		if(index != -1) {
			propertyParsers.splice(index, 1);
		}
	}


	//---------------------------------
	//	Parsing
	//---------------------------------

	/**
	 *	@copy IBlockParser#isSingleLineBlock()
	 */
	public function isSingleLineBlock(block:Block):Node
	{
		return (block.content && block.content.charAt(0) == "%");
	}

	/**
	 *	@copy IBlockParser#parse()
	 */
	public function parse(block:Block):Node
	{
		// Exit if first character is not a percent sign
		if(!block.content || block.content.charAt(0) != "%") {
			return null;
		}
		
		var node:Node;
		var lexer:Lexer = new Lexer(block.content);
		
		// Parse name
		var name:String;
		if(!(name = lexer.match(/([^ ]+)\s*/))) {
			throw new BlockParseError(block, 'Expected component name');
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
