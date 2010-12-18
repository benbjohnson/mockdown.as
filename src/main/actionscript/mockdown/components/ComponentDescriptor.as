package mockdown.components
{
import mockdown.core.Type;

import flash.errors.IllegalOperationError;

/**
 *	This class describes how a component should be instantiated at runtime. It
 *	is intended to provide psuedo-inheritence to generated components.
 */
public class ComponentDescriptor
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function ComponentDescriptor(parent:*=null)
	{
		super();
		this.parent = parent;
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Property values
	//---------------------------------
	
	/**
	 *	A hash of property values to set on the component when it's
	 *	instanitated.
	 */
	public var values:Object = {};


	//---------------------------------
	//	Children
	//---------------------------------
	
	/**
	 *	A list of descriptors that should be instantiated and added to the
	 *	children of the instantiation of this descriptor. Note that the
	 *	children are not related to the <code>parent</code> property.
	 */
	public var children:Array = [];


	//---------------------------------
	//	Meta
	//---------------------------------
	
	/**
	 *	The meta data for this descriptor.
	 *
	 *	@see mockdown.core.Type
	 */
	public var meta:Object;


	//---------------------------------
	//	Parent
	//---------------------------------
	
	private var _parent:*;
	
	/**
	 *	The parent class or descriptor that this descriptor is based on.
	 */
	public function get parent():*
	{
		return _parent;
	}

	public function set parent(value:*):void
	{
		// Verify that parent is either a class or descriptor
		if(value != null && !(value is Class) && !(value is ComponentDescriptor)) {
			throw new ArgumentError("Descriptor parent must be a class or another descriptor");
		}
		
		// Make sure this descriptor is not a parent of a parent
		if(value) {
			var p:ComponentDescriptor = value as ComponentDescriptor;
			while(p) {
				if(p == this) {
					throw new IllegalOperationError("Cannot create circular parent descriptor hierarchy");
				}
				p = p.parent as ComponentDescriptor;
			}
		}
		
		// Retrieve meta data based on parent if it's a class
		if(value is Class) {
			meta = Type.describe(value as Class);
		}
		// Otherwise copy meta from parent
		else if(value is ComponentDescriptor) {
			meta = value.meta;
		}
		
		_parent = value;
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Factory
	//---------------------------------

	/**
	 *	A factory method that creates a component instance based on the
	 *	properties on this descriptor and its parent.
	 *
	 *	@return  A component as described by this descriptor.
	 */
	public function newInstance():Component
	{
		var component:Component;
		
		// Instantiate if parent is a class
		if(parent is Class) {
			component = new parent() as Component;
		}
		// Create new instance from parent descriptor
		else if(parent is ComponentDescriptor) {
			component = parent.newInstance();
		}
		// If parent is missing then throw an error
		else {
			throw new IllegalOperationError("Cannot create new instance from descriptor when missing parent");
		}
		
		// Set properties
		for(var key:String in values) {
			component[key] = values[key];
		}
		
		// Add child components
		for each(var child:ComponentDescriptor in children) {
			component.addChild(child.newInstance());
		}

		return component;
	}
}
}
