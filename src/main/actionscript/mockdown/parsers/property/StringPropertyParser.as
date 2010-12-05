package mockdown.parsers.property
{
import mockdown.components.Node;

import flash.errors.IllegalOperationError;

/**
 *	This class parses a string value and assigns it's to a node property.
 */
public class StringPropertyParser implements IPropertyParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function StringPropertyParser()
	{
		super()
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@copy IPropertyParser#canParseType()
	 */
	public function canParseType(type:String):void
	{
		return (type == "string");
	}
	
	/**
	 *	@copy IPropertyParser#parse()
	 */
	public function parse(node:Node, property:String, value:String):void
	{
		node[property] = value;
	}
}
}
