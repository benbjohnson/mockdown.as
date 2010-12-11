package mockdown.parsers
{
import mockdown.components.Component;
import mockdown.components.NodeDescriptor;
import mockdown.components.loaders.ComponentLoader;
import mockdown.components.properties.BooleanProperty;
import mockdown.components.properties.ComponentProperty;
import mockdown.components.properties.NumberProperty;
import mockdown.components.properties.StringProperty;
import mockdown.errors.BlockParseError;
import mockdown.parsers.block.IBlockParser;
import mockdown.parsers.property.IPropertyParser;

/**
 *	This class represents a parser for a Mockdown document.
 */
public class ComponentParser
{
	//--------------------------------------------------------------------------
	//
	//	Static Constants
	//
	//--------------------------------------------------------------------------
	
	// TODO: Refactor out of parser. Maybe a ComponentProperty registry?
	private const PROPERTY_TYPES:Object = {
		"string":  StringProperty,
		"int":     NumberProperty,
		"uint":    NumberProperty,
		"decimal": NumberProperty,
		"boolean": BooleanProperty
	};
	
	
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
	 *	Parses Mockdown formatted content into a component.
	 *
	 *	@param content  The content to parse.
	 *
	 *	@return         The component defined by the content.
	 */
	public function parse(content:String):Component
	{
		var component:Component = new Component();
		var root:Block = createBlockTree(content);
		
		// Parse pragmas at the root
		parsePragmas(root, component);
		
		// Find first node definition and parse descriptors from there
		var blocks:Array = root.children.filter(function(item:Block,...args):Boolean{return item.content.charAt(0) == "%"});
		
		// Parse root node
		if(blocks.length == 1) {
			component.descriptor = parseNode(blocks[0] as Block);
		}
		// Throw error if we have more than one root nodes
		if(blocks.length > 1) {
			throw new BlockParseError(root, 'Only one root node is allowed');
		}
		
		return component;
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
	//	Pragmas
	//---------------------------------

	/**
	 *	Parses the direct children of the root block to define the component.
	 */
	private function parsePragmas(root:Block, component:Component):void
	{
		// Find pragma blocks
		for each(var block:Block in root.children) {
			if(block.content.charAt(0) == "!") {
				parsePragma(block, component);
			}
		}
	}

	// TODO: Consider removing the bang for pragmas
	private function parsePragma(block:Block, component:Component):void
	{
		var lexer:Lexer = new Lexer(block.content);
		
		// Determine the type of pragma
		var name:String;
		if(!(name = lexer.match(/^!(\w+)\s*/))) {
			throw new BlockParseError(block, 'Expected pragma name');
		}
		
		switch(name) {
			case 'var': parsePragmaVar(block, component, lexer); break;
			case 'import': parsePragmaImport(block, component, lexer); break;
			default: throw new BlockParseError(block, "Invalid pragma: " + name);
		}
	}

	private function parsePragmaVar(block:Block, component:Component, lexer:Lexer):void
	{
		// Determine the property name
		var name:String = lexer.match(/^(\w+)\s*/);
		if(!name) {
			throw new BlockParseError(block, 'Expected property name');
		}

		// Parse property type
		var type:String = lexer.match(/^:(\w+)\s*/) || "string";
		var clazz:Class = PROPERTY_TYPES[type];
		if(clazz == null) {
			throw new BlockParseError(block, "Invalid property type: " + type);
		}

		// Determine options on property
		var options:Object = {};
		if(lexer.match(/^\(\s*/)) {
			while(lexer.match(/^\s*\)/) == null) {
				// Find option key
				var key:String = lexer.match(/^(\w+)/);
				if(key == null) {
					throw new BlockParseError(block, "Expected property option name");
				}

				// Make sure there's an equals sign
				if(!lexer.match("=")) {
					throw new BlockParseError(block, "Expected '='");
				}
				
				// Parse value
				var value:String = lexer.match(/^"([^"]*)"/);
				if(value == null) {
					throw new BlockParseError(block, "Expected \"<value>\" for option: " + key);
				}
				
				// Throw error if key already defined
				if(options[key] != null) {
					throw new BlockParseError(block, "Property option already defined: " + key);
				}

				// Assign value to key
				options[key] = value;
				
				// Slurp comma and space
				lexer.match(/^(?:, +)?/);
			}
		}

		// Create property
		var property:ComponentProperty = clazz['create'](name, type, options);
		component.addProperty(property);
	}


	// TODO: Support library versioning
	private function parsePragmaImport(block:Block, component:Component, lexer:Lexer):void
	{
		// Determine the import name
		var name:String = lexer.match(/^(\w+)\s*/);
		if(!name) {
			throw new BlockParseError(block, 'Expected library name for import');
		}

		// Determine import path
		loader.addLibrary(name);
	}


	//---------------------------------
	//	Nodes
	//---------------------------------

	private function parseNode(block:Block):NodeDescriptor
	{
		var lexer:Lexer = new Lexer(block.content);
		var descriptor:NodeDescriptor = new NodeDescriptor();

		// Determine the component
		var name:String = lexer.match(/^%(\w+)\s*/);
		if(!name) {
			throw new BlockParseError(block, "Expected component name");
		}

		// Find component
		descriptor.component = loader.find(name);
		if(!descriptor.component) {
			throw new BlockParseError(block, "Component not found: " + name);
		}
		
		// Parse property values
		parseNodeProperties(block, descriptor, lexer);
		
		// Parse child nodes
		for each(var childBlock:Block in block.children) {
			var childDescriptor:NodeDescriptor = parseNode(childBlock);
			descriptor.addChild(childDescriptor);
		}
		
		return descriptor;
	}

	private function parseNodeProperties(block:Block, descriptor:NodeDescriptor, lexer:Lexer):void
	{
		// Parse key/value pairs
		while(!lexer.eof) {
			var negate:Boolean = (lexer.match(/^!/) != null);
			var key:String = lexer.match(/^\w+/);
			if(key) {
				var property:ComponentProperty = descriptor.getProperty(key);

				// Verify property exists on component
				if(!property) {
					throw new BlockParseError(block, "Property doesn't exist: " + key);
				}
				
				// If a colon is next, retrieve the value
				var value:String;
				if(lexer.match(/=/)) {
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
					// Make sure this is a boolean property
					if(property.type != "boolean") {
						throw new BlockParseError(block, "A value is required for non-boolean property: " + key);
					}
					
					// A key with a bang prefixed is false
					if(negate) {
						value = "false";
					}
					// A key alone is true.
					else {
						value = "true";
					}
				}
				
				// Assign to data object
				descriptor.setPropertyValue(key, value);
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
	}
}
}
