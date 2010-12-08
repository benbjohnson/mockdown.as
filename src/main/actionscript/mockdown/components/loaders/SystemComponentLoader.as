package mockdown.components.loaders
{
import mockdown.components.Component;

/**
 *	This class contains the default system components used by mockdown.
 */
public class SystemComponentLoader extends RegistryComponentLoader
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function SystemComponentLoader(parent:ComponentLoader=null)
	{
		super(parent);
		
		// Add components
		register(new ActionScriptComponent(Column));
			
		// TODO: Seal system component loader.
	}
}
}
