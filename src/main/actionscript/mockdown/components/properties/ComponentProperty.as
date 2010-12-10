package mockdown.components.properties
{
import mockdown.components.Component;
import mockdown.components.Node;

import flash.errors.IllegalOperationError;

/**
 *	This class represents a property defined on a component.
 */
public class ComponentProperty
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *	
	 *	@param name  The name of the property.
	 */
	public function ComponentProperty(name:String=null, type:String=null)
	{
		super();
		this.name = name;
		this.type = type;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Component
	//---------------------------------
	
	private var _component:Component;
	
	/**
	 *	The component that this property is attached to.
	 */
	public function get component():Component
	{
		return _component;
	}

	public function set component(value:Component):void
	{
		verifyUnsealed();		
		_component = value;
	}

	//---------------------------------
	//	Sealed
	//---------------------------------
	
	private var _sealed:Boolean = false;
	
	/**
	 *	A flag stating if the property definition can be changed.
	 */
	public function get sealed():Boolean
	{
		return _sealed;
	}


	//---------------------------------
	//	Name
	//---------------------------------
	
	private var _name:String;
	
	/**
	 *	The name of the property.
	 */
	public function get name():String
	{
		return _name;
	}

	public function set name(value:String):void
	{
		verifyUnsealed();
		
		// Do not allow the name to change when attached to a component
		if(component) {
			throw new IllegalOperationError("Property name cannot change when a property is attached to a component");
		}
		
		_name = value;
	}

	//---------------------------------
	//	Type
	//---------------------------------
	
	private var _type:String;
	
	/**
	 *	The data type of the property.
	 */
	public function get type():String
	{
		return _type;
	}

	public function set type(value:String):void
	{
		verifyUnsealed();		
		_type = value;
	}


	//---------------------------------
	//	Default value
	//---------------------------------
	
	private var _defaultValue:*;
	
	/**
	 *	The value to return if a property hasn't been set
	 */
	public function get defaultValue():String
	{
		return _defaultValue;
	}

	public function set defaultValue(value:String):void
	{
		verifyUnsealed();		
		_defaultValue = value;
	}


	//---------------------------------
	//	Nullable
	//---------------------------------
	
	private var _nullable:Boolean = true;
	
	/**
	 *	A flag stating if the property can be set to null. If false, then value
	 *	will convert null into a default value for the given type.
	 */
	public function get nullable():Boolean
	{
		return _nullable;
	}

	public function set nullable(value:Boolean):void
	{
		verifyUnsealed();		
		_nullable = value;
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
	 *	Parses a string value and assigns it to the property
	 *
	 *	@param value  The string value to parse.
	 *	
	 *	@return       The native typed, parsed value.
	 */
	public function parse(value:*):*
	{
		throw new IllegalOperationError("You must use a subclass of ComponentProperty to parse values");
	}


	//---------------------------------
	//	Alternate property
	//---------------------------------

	/**
	 *	Retrieves the alternate property to use for a given value.
	 *
	 *	@param value  The value.
	 *	
	 *	@return       A different field to assign the value to if applicable.
	 *	              Otherwise, null.
	 */
	public function getAlternatePropertyName(value:*):String
	{
		return null;
	}

	/**
	 *	Retrieves the value to assign to the alternate property if an alternate
	 *	property is specified.
	 *
	 *	@param value  The value.
	 *	
	 *	@return       A modified value if used on an alternate field. Otherwise
	 *	              it returns the original value.
	 */
	public function getAlternatePropertyValue(value:*):*
	{
		return value;
	}


	//---------------------------------
	//	Seal
	//---------------------------------

	/**
	 *	Restricts the component from changing any properties. Once a component
	 *	is sealed, it cannot be unsealed.
	 */
	public function seal():void
	{
		_sealed = true;
	}

	/**
	 *	Checks if a property has been sealed yet and throws an error if it has.
	 */
	protected function verifyUnsealed():void
	{
		// Do not allow changes if sealed
		if(sealed) {
			throw new IllegalOperationError("Cannot change settings on a property after it is sealed.")
		}
	}
}
}
