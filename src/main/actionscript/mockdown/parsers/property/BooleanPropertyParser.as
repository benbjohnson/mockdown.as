package mockdown.parsers.property
{
import mockdown.components.Node;
import mockdown.errors.BlockParseError;

import org.as3commons.reflect.Field;
import org.as3commons.reflect.MetaData;
import org.as3commons.reflect.Type;


/**
 *	This class parses a boolean value and assigns it to a property on a node.
 */
public class BooleanPropertyParser implements IPropertyParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function BooleanPropertyParser()
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
	public function canParseType(type:String):Boolean
	{
		return (type == "boolean");
	}

	/**
	 *	@copy IPropertyParser#parse()
	 */
	public function parse(node:Node, property:String, value:String):void
	{
		if(value == "true") {
			node[property] = true;
		}
		else if(value == "false") {
			node[property] = false;
		}
		else {
			throw new BlockParseError(node.block, "Not a valid boolean value: " + value);
		}
	}
}
}
