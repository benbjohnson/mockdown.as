package mockdown.components.loaders
{
import mockdown.test.*;
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
	
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenAddingLibrary():void
	{
		var loader:BaseComponentLoader = new BaseComponentLoader();
		loader.addLibrary("foo");
	}
}
}