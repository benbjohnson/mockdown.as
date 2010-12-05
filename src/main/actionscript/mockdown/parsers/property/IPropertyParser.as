package mockdown.parsers.property
{
import mockdown.components.Node;

/**
 *	This interface defines methods for parsing properties in component blocks.
 */
public interface IPropertyParser
{
	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	                                                                           
	/**
	 *	Checks to see if a given type can be parsed by the parser.
	 *
	 *	@param type  The data type.
	 */
	function canParseType(type:String):Boolean;

	/**
	 *	Parses a property from a node based on its data type and then assigns
	 *	the value to the appropriate property.
	 *
	 *	@param node      The node that contains the property the value will be
	 *	                 assigned to.
	 *	@param property  The name of the property on the node.
	 *	@param value     The string value to parse.
	 */
	function parse(node:Node, property:String, value:String):void;
}
}
