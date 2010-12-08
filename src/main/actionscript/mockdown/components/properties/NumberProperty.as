package mockdown.components.properties
{
import mockdown.components.Component;
import mockdown.components.Node;

import flash.errors.IllegalOperationError;

/**
 *	This class represents a number property defined on a component. This class
 *	supports multiple options including allowing negatives, allowing decimal
 *	places and assigning percentage values to alternate properties.
 *
 *	<p>Types can be used as shortcuts for settings on the property. The
 *	following types can be used:<br/><br/>
 *
 *	<code>int</code> - Any non-fractional number.<br/>
 *	<code>uint</code> - Positive, non-fractional number only.<br/>
 *	<code>decimal</code> - Any number.
 *	</p>
 */
public class NumberProperty extends ComponentProperty
{
	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Creates a number property from a hash of options.
	 */
	static public function create(name:String, type:String, options:Object):NumberProperty
	{
		var property:NumberProperty = new NumberProperty(name, type);
		if(options.allowNegative) {
			property.allowNegative = (options.allowNegative == "true");
		}
		if(options.percentField) {
			property.percentField = options.percentField;
		}
		return property;
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *	
	 *	@param name  The property name.
	 *	@param type  The data type.
	 */
	public function NumberProperty(name:String=null, type:String="decimal")
	{
		super(name, type);
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Type
	//---------------------------------

	/** @private */
	override public function set type(value:String):void
	{
		// Only allow certain types
		if(value == "int" || value == "uint" || value == "decimal") {
			super.type = value;
		}
		else {
			throw new ArgumentError("Numeric type not allowed: " + value);
		}
		
		// Do not allow negatives for unsigned integers
		if(value == "uint") {
			allowNegative = false;
		}
	}

	//---------------------------------
	//	Allow negative
	//---------------------------------
	
	private var _allowNegative:Boolean = true;
	
	/**
	 *	A flag stating if the property can store negative numbers.
	 */
	public function get allowNegative():Boolean
	{
		return _allowNegative;
	}

	public function set allowNegative(value:Boolean):void
	{
		verifyUnsealed();
		
		// Do not allow negatives when type is "uint"
		if(type == "uint" && value == true) {
			throw new ArgumentError("Cannot allow negatives on a uint property");
		}
		
		_allowNegative = value;
	}

	//---------------------------------
	//	Percent field
	//---------------------------------
	
	private var _percentField:String;
	
	/**
	 *	The field that a value should be assigned to if the value is
	 *	represented as a percentage.
	 */
	public function get percentField():String
	{
		return _percentField;
	}

	public function set percentField(value:String):void
	{
		verifyUnsealed();
		_percentField = value;
	}



	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/** @private */
	override public function parse(value:*):*
	{
		// Use numbers as is unless a type conversion occurs
		if(value is Number) {
			if(type == "int") {
				return Math.floor(value);
			}
			else if(type == "uint") {
				return Math.floor(Math.max(0, value));
			}
			else {
				return value;
			}
		}
		// Parse strings
		else if(value is String) {
			// Determine the regex to use
			var regex:RegExp = /^-?\d+(?:\.\d+)?$/;
			var match:Array  = value.match(regex);

			if(match) {
				var stringValue:String = match[0];
				var num:Number = (type == "decimal" ? parseFloat(stringValue) : parseInt(stringValue));
			
				// Validate positive-only numbers
				if(!allowNegative && num < 0) {
					throw new ArgumentError("Value can not be negative for property: " + name);
				}

				return num;
			}
			else {
				throw new ArgumentError("Value is not a numeric: " + value);
			}
		}
		// Objects and nulls are null
		else {
			return null;
		}
	}
	
	// TODO: Implement alternate field to support percent field
}
}
