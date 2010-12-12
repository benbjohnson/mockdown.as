package mockdown.components.loaders
{
import mockdown.components.Component;

/**
 *	This class loads ActionScript-based components at runtime.
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
	 *	Registers a component by name.
	 *
	 *	@param component  The component to register.
	 */
	public function register(component:Component):void
	{
		if(component) {
			component.loader = this;
			components[component.name] = component;
			component.seal();
		}
	}


	//---------------------------------
	//	Find
	//---------------------------------

	/**
	 *	@copy ComponentLoader#find()
	 */
	override public function find(name:String):Component
	{
		// Find component if registered
		if(components[name] != null) {
			return components[name] as Component;
		}
		// Otherwise try to search through the parent loaders
		else {
			return super.find(name);
		}
	}
}
}
