package mockdown.components.loaders
{
public class MockdownComponentLoaderTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var loader:MockdownComponentLoader;

	[Before]
	public function setup():void
	{
		loader = new MockdownComponentLoader();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldFindComponent():void
	{
		var component:MockdownComponent = loader.find("foo");
		// Assert.assertEquals(component);
	}
}
}
