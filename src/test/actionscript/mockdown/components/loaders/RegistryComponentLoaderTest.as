package mockdown.components.loaders
{
import mockdown.test.*;

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

	[Test]
	public function shouldThrowErrorWhenRegisteringClassWithMissingName():void
	{
		assertThrowsWithMessage(ArgumentError, "Name is required when registering a component", function():void{
			loader.register(null, Object);
		});
	}

	[Test]
	public function shouldThrowErrorWhenRegisteringClassWithMissingType():void
	{
		assertThrowsWithMessage(ArgumentError, "Component type is required when registering a component", function():void{
			loader.register("foo", null);
		});
	}

	[Test]
	public function shouldThrowErrorWhenRegisteringClassWithNonClassType():void
	{
		assertThrowsWithMessage(ArgumentError, "Component type must be a class", function():void{
			loader.register("foo", {});
		});
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

	[Test]
	public function shouldThrowErrorWhenAddingLibrary():void
	{
		assertThrowsWithMessage(IllegalOperationError, "This loader does not support adding libraries", function():void{
			loader.addLibrary("foo");
		});
	}
}
}

import mockdown.components.Component;
class TestClass extends Component{}