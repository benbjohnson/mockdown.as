package mockdown.parsers.block
{
import mockdown.components.Node;
import mockdown.core.Document;
import mockdown.errors.BlockParseError;
import mockdown.errors.ParseError;

/**
 *	This class parses blocks into node descriptors.
 */
public class NodeBlockParser implements IBlockParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function NodeBlockParser()
	{
		super()
	}



	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Parsing
	//---------------------------------

	/**
	 *	@copy IBlockParser#parse()
	 */
	public function parse(block:Block, component:Component, parent:Node):Boolean
	{
		// Exit if first character is not a percent sign
		if(!block.content || block.content.charAt(0) != "%") {
			return false;
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
