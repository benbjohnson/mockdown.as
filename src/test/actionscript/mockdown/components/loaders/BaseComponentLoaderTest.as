package mockdown.components.loaders
{
import asunit.framework.Assert;

public class BaseComponentLoaderTest
{
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function constructorShouldSetParent():void
	{
		var parent:BaseComponentLoader = new BaseComponentLoader();
		var loader:BaseComponentLoader = new BaseComponentLoader(parent);
		Assert.assertEquals(parent, loader.parent);
	}
}
}