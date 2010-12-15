package mockdown.components.loaders
{
import mockdown.components.Column;
import mockdown.components.Row;

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
		
		register("row", Row);
		register("col", Column);
	}
}
}
