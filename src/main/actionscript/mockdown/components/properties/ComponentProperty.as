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


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
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
