package mockdown.components
{
import mockdown.components.loaders.ComponentLoader;
import mockdown.components.properties.ComponentProperty;

import flash.errors.IllegalOperationError;

/**
 *	Instances of this class are used to define a class system within the
 *	mockdown system.
 */
public class Component
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Component(name:String=null)
	{
		super();
		this.name = name;
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Component loader
	//---------------------------------
	
	private var _loader:ComponentLoader;
	
	/**
	 *	The component loader that loaded this component. A loader can only be
	 *	assigned to a component once.
	 */
	public function get loader():ComponentLoader
	{
		return _loader;
	}

	public function set loader(value:ComponentLoader):void
	{
		verifyUnsealed();
		_loader = value;
	}
	
	
	//---------------------------------
	//	Name
	//---------------------------------
	
	private var _name:String;
	
	/**
	 *	The name of the component.
	 */
	public function get name():String
	{
		return _name;
	}

	public function set name(value:String):void
	{
		verifyUnsealed();
		_name = value;
	}
	
	
	//---------------------------------
	//	Parent
	//---------------------------------
	
	private var _parent:Component;
	
	/**
	 *	Defines the parent class for this component. A component inherits the
	 *	properties and structure of its parent component.
	 */
	public function get parent():Component
	{
		return _parent;
	}

	public function set parent(value:Component):void
	{
		verifyUnsealed();
		
		// Make sure this component is not a parent of a parent
		if(value) {
			var p:Component = value;
			while(p) {
				if(p == this) {
					throw new IllegalOperationError("Cannot create circular parent hierarchy");
				}
				p = p.parent;
			}
		}
		
		_parent = value;
	}


	//---------------------------------
	//	Properties
	//---------------------------------
	
	/**
	 *	A lookup of properties defined by this component.
	 */
	private var _properties:Object = {};

	/**
	 *	A list of all properties on the component.
	 */
	public function get properties():Array
	{
		var arr:Array = [];
		for each(var property:ComponentProperty in _properties) {
			arr.push(property);
		}
		return arr;
	}


	//---------------------------------
	//	Sealed
	//---------------------------------
	
	private var _sealed:Boolean = false;
	
	/**
	 *	A flag stating if the component definition can be changed.
	 */
	public function get sealed():Boolean
	{
		return _sealed;
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Property management
	//---------------------------------

	/**
	 *	Defines a property on this component.
	 *
	 *	@param property  The property to add.
	 */
	public function addProperty(property:ComponentProperty):void
	{
		verifyUnsealed();
		
		// Verify not null
		if(!property) {
			throw new ArgumentError("Cannot add null property");
		}
		// Verify property has a name
		if(property.name == null || property.name == "") {
			throw new ArgumentError("Cannot add property with a null or blank name");
		}
		// Validate that property hasn't already been added
		if(getProperty(property.name) != null) {
			throw new ArgumentError("Property already added with the same name: " + property.name);
		}
		
		property.component = this;
		_properties[property.name] = property;
	}

	/**
	 *	Removes a property on this component.
	 *
	 *	@param property  The property to remove.
	 */
	public function removeProperty(property:ComponentProperty):void
	{
		verifyUnsealed();
		
		if(property) {
			_properties[property.name] = null;
			delete _properties[property.name];
			property.component = null;
		}
	}

	/**
	 *	Retrieves the definition of a property on the component by name.
	 *
	 *	@param name  The name of the property.
	 *
	 *	@return      The property with the given name if found. Otherwise, null.
	 */
	public function getProperty(name:String):ComponentProperty
	{
		return _properties[name] as ComponentProperty;
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

		// Seal each property
		var properties:Array = this.properties;
		for each(var property:ComponentProperty in properties) {
			property.seal();
		}
	}

	/**
	 *	Checks if a property has been sealed yet and throws an error if it has.
	 */
	protected function verifyUnsealed():void
	{
		// Do not allow changes if sealed
		if(sealed) {
			throw new IllegalOperationError("Cannot change settings on a component after it is sealed.")
		}
	}
}
}
