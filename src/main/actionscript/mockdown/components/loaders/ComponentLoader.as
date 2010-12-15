package mockdown.components.loaders
{
import mockdown.components.Component;

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
	 *	Attempts to locate the component by name. The returned object can be an
	 *	ActionScript subclass of <code>Component</code> or it can be an instance
	 *	of <code>ComponentDescriptor</code>.
	 *
	 *	@param name  The name of the component to load.
	 *
	 *	@return      The component class descriptor if found. Otherwise,
	 *	             null.
	 */
	function find(name:String):*;

	/**
	 *	Searches for a component type with the given name and instantiates it.
	 *
	 *	@param name  The name of the component to load.
	 *
	 *	@return      An instance of the component, if found. Otherwise, null.
	 */
	function newInstance(name:String):Component;
	
	/**
	 *	Appends a path for a library to the end of the load path.
	 *
	 *	@param name  The name of the library.
	 */
	function addLibrary(name:String):void;
}
}
