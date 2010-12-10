package mockdown.components
{
import mockdown.components.Component;
import mockdown.components.properties.ComponentProperty;
import mockdown.components.properties.FunctionProperty;

import flash.errors.IllegalOperationError;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

use namespace flash_proxy;

/**
 *	This class represents a visual node within the document object model. The
 *	properties and behavior of the node are defined by its component. In effect,
 *	a node is an instance of a component in the same way an object is an
 *	instance of a class in object oriented programming.
 */
public dynamic class Node extends Proxy
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Node(component:Component)
	{
		super();
		
		// Require the component to be defined
		if(!component) {
			throw new ArgumentError("Component must be defined when creating a node");
		}
		
		_component = component;
		
		initialize();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Internal
	//---------------------------------
	
	private var __values__:Object = {};
	
	
	//---------------------------------
	//	Component
	//---------------------------------
	
	private var _component:Component;
	
	/**
	 *	The structural definition of the node.
	 */
	public function get component():Component
	{
		return _component;
	}


	//---------------------------------
	//	Parent
	//---------------------------------
	
	/**
	 *	The parent node in the document object model.
	 */
	public var parent:Node;


	//---------------------------------
	//	Children
	//---------------------------------
	
	private var _children:Array = [];
	
	/**
	 *	The child nodes attached to this node.
	 */
	public function get children():Array
	{
		return _children.slice();
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Initialization
	//---------------------------------
	
	private function initialize():void
	{
		// Set default values
		var properties:Array = component.properties;
		for each(var property:ComponentProperty in properties) {
			// This won't work for functions
			if(property.type != "function") {
				// If there is a default value, use it.
				if(property.defaultValue != null) {
					__values__[property.name] = property.defaultValue;
				}
				// If null is not allow, parse null to get the correct value
				else {
					__values__[property.name] = property.parse(null);
				}
			}
		}
	}
	
	//---------------------------------
	//	Proxy
	//---------------------------------

	/** @private */
	flash_proxy override function setProperty(name:*, value:*):void
	{
		var property:ComponentProperty = component.getProperty(name);

		// Throw error if property doesn't exist
		if(!property) {
			throw new ReferenceError("Property does not exist on node: " + name);
		}

		// Use alternate property if required
		var altPropName:String = property.getAlternatePropertyName(value);

		if(altPropName != null) {
			this[altPropName] = property.getAlternatePropertyValue(value);
		}
		// Otherwise just assign it as normal
		else {
			__values__[property.name] = property.parse(value);
		}
	}


	/** @private */
	flash_proxy override function getProperty(name:*):*
	{
		var property:ComponentProperty = component.getProperty(name.toString());

		// Throw error if property doesn't exist
		if(!property) {
			throw new ReferenceError("Property does not exist on node: " + name);
		}

		// Return property value
		var value:* = __values__[property.name];
		if(value == undefined) {
			return null;
		}
		else {
			return value;
		}
	}

	/** @private */
	flash_proxy override function callProperty(name:*, ...rest):*
	{
		var property:ComponentProperty = component.getProperty(name.toString());

		// Throw error if property doesn't exist
		if(!property) {
			throw new ReferenceError("Function does not exist on node: " + name);
		}
		// Throw error if property is not a function
		if(!(property is FunctionProperty)) {
			throw new ReferenceError("Property is not a function on node: " + name);
		}
		
		// Execute the function on the node
		var func:Function = (property as FunctionProperty).functionReference;
		
		// Throw an error if there's no function on this property
		if(func == null) {
			throw new IllegalOperationError("No function is attached to property: " + name + ". Make sure you have appended a semi-colon at the end of your function definition.");
		}
		
		return func.apply(this, rest);
	}


	//---------------------------------
	//	Children
	//---------------------------------
	
	/**
	 *	Appends a node to the list of children.
	 *	
	 *	@param child  The node to append.
	 */
	public function addChild(child:Node):void
	{
		if(child != null) {
			child.parent = this;
			_children.push(child);
		}
	}
	
	/**
	 *	Removes a node from the list of children.
	 *	
	 *	@param child  The node to remove.
	 */
	public function removeChild(child:Node):void
	{
		if(child != null && children.indexOf(child) != -1) {
			child.parent = null;
			_children.splice(children.indexOf(child), 1);
		}
	}

	/**
	 *	Removes all children from a node.
	 */
	public function removeAllChildren():void
	{
		var children:Array = this.children;
		for each(var child:Node in children) {
			removeChild(child);
		}
	}


	//---------------------------------
	//	Utility
	//---------------------------------
	
	/**
	 *	Returns a string representation of the component.
	 */
	public function toString():String
	{
		return "[[" + component.name + "]]";
	}
}
}
