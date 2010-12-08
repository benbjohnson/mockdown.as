package mockdown.components
{
import mockdown.components.properties.*;

import asunit.framework.Assert;

public class ActionScriptComponentTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var component:ActionScriptComponent;
	

	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Arguments
	//---------------------------------

	[Test]
	public function constructorShouldSetName():void
	{
		component = new ActionScriptComponent("foo", TestComponent);
		Assert.assertEquals("foo", component.name);
	}
	
	[Test]
	public function constructorShouldSetClazz():void
	{
		component = new ActionScriptComponent("foo", TestComponent);
		Assert.assertEquals(TestComponent, component.clazz);
	}

	
	//---------------------------------
	//	Reflection
	//---------------------------------

	[Test]
	public function constructorShouldAssignComponentToProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:ComponentProperty = component.getProperty("stringProperty");
		Assert.assertEquals(component, property.component);
	}

	[Test]
	public function constructorShouldAssignNameToProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:ComponentProperty = component.getProperty("stringProperty");
		Assert.assertEquals("stringProperty", property.name);
	}

	[Test]
	public function constructorShouldCreateStringProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:StringProperty = component.getProperty("stringProperty") as StringProperty;
		Assert.assertNotNull(property);
	}

	[Test]
	public function constructorShouldCreateIntProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:NumberProperty = component.getProperty("intProperty") as NumberProperty;
		Assert.assertEquals("int", property.type);
		Assert.assertTrue(property.allowNegative);
		Assert.assertNull(property.percentField);
	}

	[Test]
	public function constructorShouldCreateUIntProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:NumberProperty = component.getProperty("uintProperty") as NumberProperty;
		Assert.assertEquals("uint", property.type);
		Assert.assertEquals("uintProperty", property.name);
		Assert.assertFalse(property.allowNegative);
	}

	[Test]
	public function constructorShouldCreateDecimalProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:NumberProperty = component.getProperty("decimalProperty") as NumberProperty;
		Assert.assertEquals("decimal", property.type);
		Assert.assertEquals("decimalProperty", property.name);
		Assert.assertTrue(property.allowNegative);
	}

	[Test]
	public function constructorShouldCreateNonNegativeProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:NumberProperty = component.getProperty("nonNegativeProperty") as NumberProperty;
		Assert.assertFalse(property.allowNegative);
	}

	[Test]
	public function constructorShouldCreatePercentFieldProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:NumberProperty = component.getProperty("percentFieldProperty") as NumberProperty;
		Assert.assertEquals("decimalProperty", property.percentField);
	}

	[Test]
	public function constructorShouldCreateBooleanProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:BooleanProperty = component.getProperty("booleanProperty") as BooleanProperty;
		Assert.assertEquals("boolean", property.type);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function constructorShouldErrorWhenFindingInvalidPropertyType():void
	{
		component = new ActionScriptComponent(null, ComponentWithInvalidPropertyType);
	}
	

	[Test]
	public function constructorShouldAssignMeasureFunction():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		Assert.assertEquals((new TestComponent()).measure(), component.measureFunction());
	}

	[Test]
	public function constructorShouldAssignLayoutFunction():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		Assert.assertEquals((new TestComponent()).layout(), component.layoutFunction());
	}

	[Test]
	public function constructorShouldAssignRenderFunction():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		Assert.assertEquals((new TestComponent()).render(), component.renderFunction());
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function constructorShouldThrowErrorWhenAssigningNonFunctionsToMethods():void
	{
		new ActionScriptComponent(null, ComponentWithInvalidMethodType);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function constructorShouldThrowErrorWhenAssigningInvalidMethodName():void
	{
		new ActionScriptComponent(null, ComponentWithInvalidMethodName);
	}


	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------
	
}
}

import mockdown.components.Component;
class TestComponent extends Component
{
	[Property]
	public var stringProperty:String;

	[Property]
	public var intProperty:int;

	[Property]
	public var uintProperty:uint;

	[Property(allowNegative="false")]
	public var nonNegativeProperty:int;

	[Property(percentField="decimalProperty")]
	public var percentFieldProperty:int;

	[Property(type="decimal")]
	public var decimalProperty:*;

	[Property]
	public var booleanProperty:Boolean;

	[Method]
	public var measure:Function = function():String{return "measure!"};

	[Method]
	public var layout:Function = function():String{return "layout!"};

	[Method]
	public var render:Function = function():String{return "render!"};
}

class ComponentWithInvalidPropertyType extends Component
{
	[Property]
	public var stringProperty:Object;
}

class ComponentWithInvalidMethodType extends Component
{
	[Method]
	public var layout:String;
}

class ComponentWithInvalidMethodName extends Component
{
	[Method]
	public var no_such_method:Function;
}
