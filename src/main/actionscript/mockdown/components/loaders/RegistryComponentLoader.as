package mockdown.components.loaders
{
import mockdown.components.BaseComponent;

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
	//	BaseComponent registration
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
			throw new ArgumentError("BaseComponent type is required when registering a component");
		}
		// Throw error if component type is not a class
		if(!(type is Class)) {
			throw new ArgumentError("BaseComponent type must be a class");
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
		// Search through the parent loaders
		var type:* = super.find(name);
		if(type != null) {
			return type;
		}
		
		// If not found, find component if registered
		return components[name];
	}
}
}
