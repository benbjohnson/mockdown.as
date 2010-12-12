package mockdown.components.loaders
{
import mockdown.components.ActionScriptComponent;
import mockdown.components.Component;
import mockdown.components.definitions.BaseComponent;
import mockdown.components.definitions.Column;
import mockdown.components.definitions.Row;

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
		
		var base:Component = new ActionScriptComponent("node", BaseComponent);
		register(base);
		register(new ActionScriptComponent("col", Column, base));
		register(new ActionScriptComponent("row", Row, base));
	}
}
}
