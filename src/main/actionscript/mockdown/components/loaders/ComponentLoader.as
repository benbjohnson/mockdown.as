package mockdown.components.loaders
{
import mockdown.components.Component;
import mockdown.components.Node;

/**
 *	This interface defines methods for loading components by name at runtime.
 */
public interface ComponentLoader
{
	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Attempts to locate the component by name.
	 *
	 *	@param name  The name of the component to load.
	 *
	 *	@return      The component if found. Otherwise, null.
	 */
	function find(name:String):Component;
	
	/**
	 *	Finds and instantiates a component into a node.
	 *
	 *	@param name  The name of the component.
	 *
	 *	@return      An instance of a component if found. Otherwise, null.
	 */
	function newInstance(name:String):Node;

	
	/**
	 *	Appends a path for a library to the end of the load path.
	 *
	 *	@param name  The name of the library.
	 */
	function addLibrary(name:String):void;
}
}
