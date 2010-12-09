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
	public function constructorShouldImplicitlyCreateStringProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:StringProperty = component.getProperty("implicitStringProperty") as StringProperty;
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
	public function constructorShouldImplicitlyCreateIntProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:NumberProperty = component.getProperty("implicitIntProperty") as NumberProperty;
		Assert.assertEquals("int", property.type);
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
	public function constructorShouldImplicitlyCreateUIntProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:NumberProperty = component.getProperty("implicitUIntProperty") as NumberProperty;
		Assert.assertEquals("uint", property.type);
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
	public function constructorShouldCreateDefaultValueProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:NumberProperty = component.getProperty("defaultValueProperty") as NumberProperty;
		Assert.assertEquals(12, property.defaultValue);
	}

	[Test]
	public function constructorShouldCreateNonNullableProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:NumberProperty = component.getProperty("nonNullableProperty") as NumberProperty;
		Assert.assertFalse(property.nullable);
	}

	[Test]
	public function constructorShouldCreateBooleanProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:BooleanProperty = component.getProperty("booleanProperty") as BooleanProperty;
		Assert.assertEquals("boolean", property.type);
	}

	[Test]
	public function constructorShouldImplicitlyCreateBooleanProperty():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:BooleanProperty = component.getProperty("implicitBooleanProperty") as BooleanProperty;
		Assert.assertEquals("boolean", property.type);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function constructorShouldErrorWhenFindingInvalidPropertyType():void
	{
		component = new ActionScriptComponent(null, ComponentWithInvalidPropertyType);
	}
	

	[Test]
	public function constructorShouldCreateFunction():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:FunctionProperty = component.getProperty("functionProperty") as FunctionProperty;
		Assert.assertEquals("function", property.type);
		Assert.assertEquals("foo!", property.functionReference());
	}

	[Test]
	public function constructorShouldImplicitlyCreateFunction():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:FunctionProperty = component.getProperty("implicitFunctionProperty") as FunctionProperty;
		Assert.assertEquals("function", property.type);
		Assert.assertEquals("bar!", property.functionReference());
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function constructorShouldThrowErrorWhenAssigningNonFunctionsToFunctions():void
	{
		new ActionScriptComponent(null, ComponentWithInvalidFunctionType);
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
	[Property(type="string")]
	public var stringProperty:*;

	public var implicitStringProperty:String;

	[Property(type="int")]
	public var intProperty:*;

	public var implicitIntProperty:int;

	[Property(type="uint")]
	public var uintProperty:*;

	public var implicitUIntProperty:uint;

	[Property(allowNegative="false")]
	public var nonNegativeProperty:int;

	[Property(percentField="decimalProperty")]
	public var percentFieldProperty:int;

	[Property(defaultValue="12")]
	public var defaultValueProperty:uint;

	[Property(nullable="false")]
	public var nonNullableProperty:uint;

	[Property(type="decimal")]
	public var decimalProperty:*;

	[Property(type="boolean")]
	public var booleanProperty:*;

	public var implicitBooleanProperty:Boolean;

	[Function]
	public var functionProperty:Function = function():String{return "foo!"};

	public var implicitFunctionProperty:Function = function():String{return "bar!"};
}

class ComponentWithInvalidPropertyType extends Component
{
	[Property]
	public var stringProperty:Object;
}

class ComponentWithInvalidFunctionType extends Component
{
	[Function]
	public var layout:String;
}

class ComponentWithInvalidFunctionName extends Component
{
	[Function]
	public var no_such_function:Function;
}
