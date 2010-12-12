package mockdown.components
{
import mockdown.components.properties.ComponentProperty;

import flash.errors.IllegalOperationError;

/**
 *	This class describes how a node tree should be created when a component
 *	is instantiated at runtime.
 */
public class NodeDescriptor
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function NodeDescriptor()
	{
		super();
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Internal
	//---------------------------------
	
	/**
	 *	A lookup of property values to set on node when instantiated.
	 */
	private var values:Object = {};


	//---------------------------------
	//	Component
	//---------------------------------
	
	private var _component:Component;
	
	/**
	 *	The component that this descriptor is attached to.
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
	//	Children
	//---------------------------------
	
	private var _children:Array = [];

	/**
	 *	A list of children to be attached to the node.
	 */
	public function get children():Array
	{
		return _children.slice();
	}


	//---------------------------------
	//	Parent
	//---------------------------------
	
	private var _parent:NodeDescriptor;
	
	/**
	 *	The parent descriptor. Descriptors are a tree of nodes that are built
	 *	at runtime when a component is instantiated.
	 */
	public function get parent():NodeDescriptor
	{
		return _parent;
	}

	public function set parent(value:NodeDescriptor):void
	{
		verifyUnsealed();
		
		// Make sure this descriptor is not a parent of a parent
		if(value) {
			var p:NodeDescriptor = value;
			while(p) {
				if(p == this) {
					throw new IllegalOperationError("Cannot create circular parent descriptor hierarchy");
				}
				p = p.parent;
			}
		}
		
		_parent = value;
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
	//	Factory
	//---------------------------------

	/**
	 *	A factory method that creates a node based on the properties on this
	 *	descriptor. This method works recursively with any child descriptors.
	 *
	 *	@return  A node as described by this descriptor.
	 */
	public function newInstance():Node
	{
		var node:Node = new Node(component);

		// Set properties
		for(var propName:String in values) {
			node[propName] = values[propName];
		}
		
		// Create child nodes
		var children:Array = this.children;
		for each(var child:NodeDescriptor in children) {
			node.addChild(child.newInstance());
		}

		return node;
	}


	//---------------------------------
	//	Child management
	//---------------------------------

	/**
	 *	Adds a child descriptor.
	 *
	 *	@param descriptor   The descriptor to add.
	 */
	public function addChild(descriptor:NodeDescriptor):void
	{
		verifyUnsealed();
		
		// Verify descriptor exists
		if(!descriptor) {
			throw new ArgumentError("Child descriptor cannot be null");
		}
		// Verify descriptor has not been added yet
		if(_children.indexOf(descriptor) != -1) {
			throw new ArgumentError("Child descriptor has already been added");
		}
		
		// Verify child does not exist as a parent
		var desc:NodeDescriptor = this;
		while(desc) {
			if(desc == descriptor) {
				throw new ArgumentError("Child descriptor is already a parent descriptor");
			}
			desc = desc.parent;
		}
		
		// Attach descriptor
		descriptor.parent = this;
		_children.push(descriptor);
	}

	/**
	 *	Removes a child descriptor.
	 *
	 *	@param descriptor   The descriptor to remove.
	 */
	public function removeChild(descriptor:NodeDescriptor):void
	{
		verifyUnsealed();
		
		var index:int = children.indexOf(descriptor);
		if(descriptor && index != -1) {
			descriptor.parent = null;
			_children.splice(index, 1);
		}
	}

	/**
	 *	Removes all child descriptors.
	 */
	public function removeAllChildren():void
	{
		verifyUnsealed();
		
		var children:Array = this.children;
		for each(var child:NodeDescriptor in children) {
			removeChild(child);
		}
	}
	
		
	//---------------------------------
	//	Property management
	//---------------------------------

	/**
	 *	Sets the value to assign to a property when the node is instantiated.
	 *
	 *	@param name   The name of the property.
	 *	@param value  The value to assign to the property.
	 */
	public function setPropertyValue(name:String, value:*):void
	{
		verifyUnsealed();
		
		// Validate that property exists on component
		var property:ComponentProperty = getProperty(name);
		if(!property) {
			throw new ArgumentError("Property does not exist on component: " + name);
		}
		
		values[name] = value;
	}

	/**
	 *	Retrieves the value to assign to a property when the node is
	 *	instantiated.
	 *
	 *	@param name   The name of the property.
	 */
	public function getPropertyValue(name:String):*
	{
		// Verify name is pass in.
		if(name == null || name == "") {
			throw new ArgumentError("Property name is required");
		}
		
		return values[name];
	}

	/**
	 *	Retrieves a property by name from the descriptor's component
	 *
	 *	@param name   The name of the property.
	 *	
	 *	@return       The property on the component if found. Otherwise null.
	 */
	public function getProperty(name:String):ComponentProperty
	{
		// Verify name is pass in.
		if(name == null || name == "") {
			throw new ArgumentError("Property name is required");
		}
		// Verify component is attached
		if(!component) {
			throw new ArgumentError("Component is not attached to descriptor");
		}
		
		return component.getProperty(name);
	}


	//---------------------------------
	//	Seal
	//---------------------------------

	/**
	 *	Restricts the descriptor from changing any properties. Once a
	 *	descriptor is sealed, it cannot be unsealed.
	 */
	public function seal():void
	{
		_sealed = true;

		// Seal each child recursively
		var children:Array = this.children;
		for each(var child:NodeDescriptor in children) {
			child.seal();
		}
	}

	/**
	 *	Checks if a descriptor has been sealed yet and throws an error if it has.
	 */
	protected function verifyUnsealed():void
	{
		// Do not allow changes if sealed
		if(sealed) {
			throw new IllegalOperationError("Cannot change settings on a descriptor after it is sealed.")
		}
	}
}
}
