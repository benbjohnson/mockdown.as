package mockdown.managers
{
import mockdown.data.Column;
import mockdown.data.Node;
import mockdown.data.Row;
import mockdown.data.Text;

import flash.events.EventDispatcher;

/**
 *	This class manages finding and creating node types.
 */
public class NodeManager extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function NodeManager()
	{
		super();
		registerSystemDefaults();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	A lookup of class-based node types registered to the node manager.
	 */
	protected var types:Object = {};
	
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Registration
	//---------------------------------
	
	/**
	 *	Registers a class by name.
	 *	
	 *	@param name   The name to register as.
	 *	@param clazz  The class to register.
	 */
	public function register(name:String, clazz:Class):void
	{
		types[name] = clazz;
	}
	
	/**
	 *	Removes registration by name.
	 *	
	 *	@param name  The name of the class to unregister.
	 */
	public function unregister(name:String):void
	{
		types[name] = null;
		delete types[name];
	}
	
	
	//---------------------------------
	//	Find
	//---------------------------------
	
	/**
	 *	Finds the class associated with the given name.
	 *	
	 *	@param name  The registered name.
	 *	
	 *	@return      The class that is registered to a name.
	 */
	public function find(name:String):Class
	{
		return types[name];
	}


	//---------------------------------
	//	Creation
	//---------------------------------
	
	/**
	 *	Creates a node by a given node.
	 *	
	 *	@param name  The registered name.
	 *	
	 *	@return      The instance of a type.
	 */
	public function create(name:String):Node
	{
		var node:Node;
		var clazz:Class = find(name);
		
		if(clazz != null) {
		 	node = new clazz() as Node;
		}
		
		return node;
	}


	//---------------------------------
	//	Defaults
	//---------------------------------
	
	/**
	 *	Registers the system defaults. This is called automatically on
	 *	initialization.
	 */
	protected function registerSystemDefaults():void
	{
		register("text", Text);
		register("col", Column);
		register("row", Row);
	}

}
}
