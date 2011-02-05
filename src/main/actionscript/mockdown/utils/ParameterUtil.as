package mockdown.utils
{
import mockdown.display.Color;

import flash.errors.IllegalOperationError;

/**
 * 	This class contains static methods for manipulating parameters strings.
 */		
public class ParameterUtil
{
	//--------------------------------------------------------------------------
	//
	//	Static Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	Stores parsed formats.
	 */
	static private var cache:Object = {}


	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Parse
	//---------------------------------
	
	/**
	 *	Parses a space-delimited string with a given format into multiple
	 *	values.
	 *	
	 *	@param obj     The object to set properties on.
	 *	@param value   The string value to parse.
	 *	@param format  The format specification.
	 */
	static public function parse(obj:Object, value:String, format:String):void
	{
		if(!obj) {
			return;
		}
		
		// Find or parse format
		var formats:Array = cache[format] as Array;
		if(!formats) {
		 	formats = Format.parse(format);
		}
		
		// Parse space-delimited value
		var values:Array = value.split(/ /);
		
		// Loop over values and parse
		var n:int = values.length;
		for(var i:int=0; i<n; i++) {
			// Throw an error if we have too many values
			if(i > formats.length-1) {
				throw new IllegalOperationError("Too many values specified");
			}
			
			var f:Format = formats[i];
			var v:String = values[i];
			
			// Set single value
			if(f.max == 1) {
				obj[f.name] = parseValue(v, f.type);
			}
			// Set an array of values
			else {
				var subvalues:Array = v.split(/,/);
				obj[f.name] = subvalues.map(function(item:String,...args):*{return parseValue(item, f.type)});
			}
		}
		
		// TODO: Check remaining formats to see if they're required.
	}
	
	static private function parseValue(value:String, type:String):*
	{
		if(type == "int") {
			if(value.search(/^-?\d+$/) != -1) {
				return parseInt(value);
			}
			else {
				throw new ArgumentError("Value is not an integer: '" + value + "'");
			}
		}
		else if(type == "decimal") {
			if(value.search(/^-?\d+(?:\.\d+)?$/) != -1) {
				return parseFloat(value);
			}
			else {
				throw new ArgumentError("Value is not a decimal: '" + value + "'");
			}
		}
		else if(type == "percent") {
			if(value.search(/^-?\d+(?:\.\d+)?%$/) != -1) {
				return parseFloat(value);
			}
			else {
				throw new ArgumentError("Value is not a percentage: '" + value + "'");
			}
		}
		else if(type == "length") {
			if(value.search(/^-?\d+px$/) != -1) {
				return parseInt(value);
			}
			else {
				throw new ArgumentError("Value is not a length: '" + value + "'");
			}
		}
		else if(type == "string") {
			return value;
		}
		else if(type == "color") {
			if(value.search(/^#[0-9A-F]{6}$/) != -1) {
				return Color.fromHex(value)
			}
			else {
				throw new ArgumentError("Value is not a color: '" + value + "'");
			}
			return value;
		}
		else {
			throw new ArgumentError("Invalid parameter format: " + type);
		}
	}
}
}


//-----------------------------------------------------------------------------
//
//	Inner Classes
//
//-----------------------------------------------------------------------------

import flash.errors.IllegalOperationError;

class Format
{
	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Parses a format specification into a list of formatting types.
	 */
	static public function parse(value:String):Array
	{
		var formats:Array = value.split(/\s+/);
		
		for(var i:int=0; i<formats.length; i++) {
			// Parse format string
			var formatString:String = formats[i];
			var match:Array = formatString.match(/^(\w+):(\w+):(\*|\+|1)$/);
			if(!match) {
				throw new IllegalOperationError("Invalid format: " + formatString);
			}
			
			// Create format object
			var cardinality:String = match[3];
			var format:Format = new Format();
			format.name = match[1];
			format.type = match[2];
			format.min  = (cardinality == "*" ? 0 : 1);
			format.max  = (cardinality == "1" ? 1 : 0);
			
			// Replace format string with object
			formats[i] = format;
		}
		
		return formats;
	}

	
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	public function Format()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	public var name:String;

	public var type:String;

	public var min:uint;

	public var max:uint;
}