package mockdown.components.loaders
{
import asunit.framework.Assert;

import flash.errors.IllegalOperationError;

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
	
	//-----------------------------
	//  Find
	//-----------------------------

	[Test]
	public function shouldFindRegisteredClass():void
	{
		loader.register("foo", Object);
		Assert.assertEquals(Object, loader.find("foo"));
	}

	[Test]
	public function shouldFindRegisteredClassInParent():void
	{
		var child:RegistryComponentLoader = new RegistryComponentLoader(loader);
		loader.register("foo", Object);
		Assert.assertEquals(Object, child.find("foo"));
	}

	[Test(expects="ArgumentError", message="Name is required when registering a component")]
	public function shouldThrowErrorWhenRegisteringClassWithMissingName():void
	{
		loader.register(null, Object);
	}

	[Test(expects="ArgumentError", message="BaseComponent type is required when registering a component")]
	public function shouldThrowErrorWhenRegisteringClassWithMissingType():void
	{
		loader.register("foo", null);
	}

	[Test(expects="ArgumentError", message="BaseComponent type must be a class")]
	public function shouldThrowErrorWhenRegisteringClassWithNonClassType():void
	{
		loader.register("foo", {});
	}


	//-----------------------------
	//  Factory
	//-----------------------------

	[Test]
	public function shouldCreateNewInstance():void
	{
		loader.register("foo", TestClass);
		Assert.assertTrue(loader.newInstance("foo") is TestClass);
	}


	//-----------------------------
	//  Library
	//-----------------------------

	[Test(expects="flash.errors.IllegalOperationError", message="This loader does not support adding libraries")]
	public function shouldThrowErrorWhenAddingLibrary():void
	{
		loader.addLibrary("foo");
	}
}
}

import mockdown.components.BaseComponent;
class TestClass extends BaseComponent{}