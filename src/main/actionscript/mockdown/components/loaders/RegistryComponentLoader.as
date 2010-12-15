package mockdown.components.loaders
{
import mockdown.components.Component;

/**
 *	This class loads registered component types by name.
 */
public class RegistryComponentLoader extends BaseComponentLoader
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function RegistryComponentLoader(parent:ComponentLoader=null)
	{
		super(parent);
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	A lookup of components by name.
	 */
	private var components:Object = {};
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Component registration
	//---------------------------------
	
	/**
	 *	Registers a component type by name.
	 *
	 *	@param name  The name to register the component as.
	 *	@param type  The component type to register.
	 */
	public function register(name:String, type:*):void
	{
		// Throw error if name is missing
		if(!name || name == "") {
			throw new ArgumentError("Name is required when registering a component");
		}
		// Throw error if component type is null
		if(type == null) {
			throw new ArgumentError("Component type is required when registering a component");
		}
		// Throw error if component type is not a class
		if(!(type is Class)) {
			throw new ArgumentError("Component type must be a class");
		}
		
		// Register component in lookup
		components[name] = type;
	}


	//---------------------------------
	//	Find
	//---------------------------------

	/**
	 *	@copy ComponentLoader#find()
	 */
	override public function find(name:String):*
	{
		// Find component if registered
		if(components[name] != null) {
			return components[name];
		}
		// Otherwise try to search through the parent loaders
		else {
			return super.find(name);
		}
	}
}
}
