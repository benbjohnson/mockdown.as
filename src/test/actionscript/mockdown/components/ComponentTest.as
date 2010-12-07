package mockdown.components
{
import mockdown.components.properties.ComponentProperty;

import asunit.framework.Assert;

public class ComponentTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var component:Component;
	
	[Before]
	public function setup():void
	{
		component = new Component();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function constructorShouldSetName():void
	{
		component = new Component("foo");
		Assert.assertEquals("foo", component.name);
	}
	

	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Loader
	//---------------------------------

	[Test]
	public function shouldSetLoader():void
	{
		var loader:TestComponentLoader = new TestComponentLoader();
		component.loader = loader;
		Assert.assertEquals(loader, component.loader);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingLoaderWhenSealed():void
	{
		component.seal();
		component.loader = new TestComponentLoader();
	}
	
	//---------------------------------
	//	Name
	//---------------------------------

	[Test]
	public function shouldSetName():void
	{
		component.name = "foo";
		Assert.assertEquals("foo", component.name);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingNameWhenSealed():void
	{
		component.seal();
		component.name = "foo";
	}
	

	//---------------------------------
	//	Parent
	//---------------------------------

	[Test]
	public function shouldSetParent():void
	{
		var parent:Component = new Component();
		component.parent = parent;
		Assert.assertEquals(parent, component.parent);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingParentWhenSealed():void
	{
		component.seal();
		component.parent = new Component();
	}
	
	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenCreatingCircularParentHiearchy():void
	{
		var c0:Component = new Component();
		var c1:Component = new Component();
		var c2:Component = new Component();
		
		c2.parent = c1;
		c1.parent = c0;
		c0.parent = c2;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Properties
	//---------------------------------

	[Test]
	public function shouldAddProperty():void
	{
		var property:ComponentProperty = new ComponentProperty("foo");
		component.addProperty(property);
		Assert.assertEquals(property, component.getProperty("foo"));
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorWhenAddingNullProperty():void
	{
		component.addProperty(null);
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorWhenAddingPropertyWithNullName():void
	{
		component.addProperty(new ComponentProperty());
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorWhenOverriddingExistingProperty():void
	{
		component.addProperty(new ComponentProperty("foo"));
		component.addProperty(new ComponentProperty("foo"));
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenAddingPropertyToSealedComponent():void
	{
		component.seal();
		component.addProperty(new ComponentProperty("foo"));
	}

	[Test]
	public function shouldRemoveProperty():void
	{
		var property:ComponentProperty = new ComponentProperty("foo");
		component.addProperty(property);
		component.removeProperty(property);
		Assert.assertNull(component.getProperty("foo"));
	}


	//---------------------------------
	//	Seal
	//---------------------------------

	[Test]
	public function shouldSeal():void
	{
		component.seal();
		Assert.assertTrue(component.sealed);
	}
}
}

import mockdown.components.loaders.ComponentLoader;
import mockdown.components.Component;
import mockdown.components.Node;
class TestComponentLoader implements ComponentLoader
{
	public function find(name:String):Component {return null;};
	public function newInstance(name:String):Node {return null;};
}
