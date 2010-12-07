package mockdown.components.loaders
{
import mockdown.components.Component;

import asunit.framework.Assert;

public class RegistryComponentLoaderTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var loader:RegistryComponentLoader;

	[Before]
	public function setup():void
	{
		loader = new RegistryComponentLoader();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldFindRegisteredComponent():void
	{
		var component:Component = new Component("test");
		loader.register(component);
		Assert.assertEquals(component, loader.find("test"));
	}

	[Test]
	public function shouldReturnNullWhenFindingUnRegisteredComponent():void
	{
		Assert.assertNull(loader.find("no_such_component"));
	}

	[Test]
	public function shouldFindParentRegisteredComponent():void
	{
		var component:Component = new Component("test");
		var subloader:RegistryComponentLoader = new RegistryComponentLoader(loader);
		loader.register(component);
		Assert.assertEquals(component, subloader.find("test"));
	}

	[Test]
	public function shouldFindOverriddenComponent():void
	{
		var c0:Component = new Component("test");
		var c1:Component = new Component("test");
		var subloader:RegistryComponentLoader = new RegistryComponentLoader(loader);
		loader.register(c0);
		subloader.register(c1);
		Assert.assertEquals(c1, subloader.find("test"));
	}
}
}