package mockdown.components.properties
{
import mockdown.components.Component;

import asunit.framework.Assert;

public class ComponentPropertyTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var property:ComponentProperty;

	[Before]
	public function setup():void
	{
		property = new ComponentProperty();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------

	[Test]
	public function constructorShouldSetName():void
	{
		property = new ComponentProperty("foo");
		Assert.assertEquals("foo", property.name);
	}

	[Test]
	public function constructorShouldSetType():void
	{
		property = new ComponentProperty("foo", "bar");
		Assert.assertEquals("bar", property.type);
	}


	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------

	//---------------------------------
	//	Component
	//---------------------------------

	[Test]
	public function shouldSetComponent():void
	{
		var component:Component = new Component();
		property.component = component;
		Assert.assertEquals(component, property.component);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingComponentWhenSealed():void
	{
		property.seal();
		property.component = new Component();
	}
	
	//---------------------------------
	//	Sealed
	//---------------------------------

	[Test]
	public function shouldBeSealed():void
	{
		property.seal();
		Assert.assertTrue(property.sealed);
	}

	//---------------------------------
	//	Name
	//---------------------------------

	[Test]
	public function shouldSetName():void
	{
		property.name = "foo";
		Assert.assertEquals("foo", property.name);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingNameWhenSealed():void
	{
		property.seal();
		property.name = "foo";
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenChangingNameAfterAttachedToComponent():void
	{
		property.component = new Component();
		property.name = "foo";
	}
	
	//---------------------------------
	//	Type
	//---------------------------------

	[Test]
	public function shouldSetType():void
	{
		property.type = "foo";
		Assert.assertEquals("foo", property.type);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingTypeWhenSealed():void
	{
		property.seal();
		property.type = "foo";
	}

	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------

	[Test(expects="flash.errors.IllegalOperationError")]
	/**
	 *	This is an abstract subclass and shouldn't be used.
	 */
	public function shouldThrowErrorWhenParsing():void
	{
		Assert.assertEquals("foo", property.parse("foo"));
	}
}
}