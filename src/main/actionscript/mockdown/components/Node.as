package mockdown.components
{
import mockdown.components.Component;
import mockdown.components.properties.ComponentProperty;
import mockdown.components.properties.FunctionProperty;

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




	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
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

		// If the property exists, use it to parse the value
		__values__[property.name] = property.parse(value);
	}


	/** @private */
	flash_proxy override function getProperty(name:*):*
	{
		var property:ComponentProperty = component.getProperty(name.toString());

		// Throw error if property doesn't exist
		if(!property) {
			throw new ReferenceError("Property does not exist on node: " + name);
		}

		return __values__[property.name];
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
		return func.apply(this, rest);
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
