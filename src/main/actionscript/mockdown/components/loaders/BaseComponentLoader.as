package mockdown.components.loaders
{
import mockdown.components.Component;
import mockdown.components.Node;

import flash.errors.IllegalOperationError;

/**
 *	This is an abstract base class of the component loader.
 */
public class BaseComponentLoader implements ComponentLoader
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function BaseComponentLoader(parent:ComponentLoader=null)
	{
		super();
		_parent = parent;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Parent
	//---------------------------------
	
	private var _parent:ComponentLoader;
	
	/**
	 *	The parent component loader. This loader is searched first before this
	 *	loader attempts to find the component.
	 */
	public function get parent():ComponentLoader
	{
		return _parent;
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	@copy ComponentLoader#find()
	 */
	public function find(name:String):Component
	{
		// Search parent loader
		if(parent) {
			return parent.find(name);
		}
		else {
			return null;
		}
	}
	
	/**
	 *	@copy ComponentLoader#newInstance()
	 */
	public function newInstance(name:String):Node
	{
		var component:Component = find(name);
		if(component) {
			return new Node(component);
		}
		else {
			return null;
		}
	}

	/**
	 *	@copy ComponentLoader#addLibrary()
	 */
	public function addLibrary(name:String):void
	{
		throw new IllegalOperationError("This loader does not support adding libraries");
	}
}
}
