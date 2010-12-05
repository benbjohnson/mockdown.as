package mockdown.parsers.property
{
import mockdown.components.Node;
import mockdown.errors.BlockParseError;

import org.as3commons.reflect.Field;
import org.as3commons.reflect.MetaData;
import org.as3commons.reflect.Type;


/**
 *	This class parses a numeric value and assigns it's to a node property. This
 *	parser has options for allowing negative numbers and assigning percentage
 *	values to alternate fields.
 */
public class NumberPropertyParser implements IPropertyParser
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function NumberPropertyParser()
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
		return (type == "integer" || type == "decimal");
	}

	/**
	 *	@copy IPropertyParser#parse()
	 */
	public function parse(node:Node, property:String, value:String):void
	{
		var type:Type = Type.forInstance(node);
		var field:Field = type.getField(property);
		var metas:Array = field.getMetaData("DataType");
		var meta:MetaData = (metas && metas.length > 0 ? metas[0] : null);
		
		// Get options from meta tag
		var dataType:String       = getDataType(meta);
		var percentField:String   = getPercentField(meta);
		var allowNegative:Boolean = getAllowNegative(meta);

		// Determine the regex to use
		var regexString:String;
		if(dataType == "integer") {
			regexString = "\\d+";
		}
		else if(dataType == "decimal") {
			regexString = "\\d+(?:\\.\\d+)";
		}
		else {
			throw ArgumentError("Invalid numeric data type on " + type.name + "." + property + ": " + dataType);
		}
		
		// Add optional negative sign
		regexString = "^(" + (allowNegative ? "-?" : "") + regexString + ")";

		// Add percentage sign at the end
		regexString += "(%?)$";

		// Attempt to parse
		var regex:RegExp = new RegExp(regexString);
		var match:Array = value.match(regex);

		// If matched, parse result
		if(match) {
			var num:Number;
			if(dataType == "integer") {
				num = parseInt(match[1]);
			}
			else {
				num = parseFloat(match[1]);
			}
			
			// Throw error is number is negative and it must be positive
			if(num < 0 && !allowNegative) {
				throw new BlockParseError(node.block, "Unsigned number not allowed on " + type.name + "." + property + ".");
			}
			
			// Assign percentages to the percent field
			if(match[2] == "%") {
				if(percentField != null) {
					parse(node, percentField, match[1]);
					node[percentField] = num;
				}
				else {
					throw new BlockParseError(node.block, "Percentage values are not allowed on " + type.name + "." + property + ".");
				}
			}
			// Assign all other numbers to the property
			else {
				node[property] = num;
			}
		}
		// Otherwise throw parser error
		else {
			throw new BlockParseError(node.block, "Unable to parse " + dataType + ": " + value);
		}
	}
	
	
	private function getDataType(meta:MetaData):String
	{
		return (meta && meta.hasArgumentWithKey("type") ? meta.getArgument("type").value : null);
	}

	private function getPercentField(meta:MetaData):String
	{
		return (meta && meta.hasArgumentWithKey("percentField") ? meta.getArgument("percentField").value : null);
	}

	private function getAllowNegative(meta:MetaData):Boolean
	{
		return (meta && (!meta.hasArgumentWithKey("allowNegative") || meta.getArgument("allowNegative").value == "true"));
	}
}
}
