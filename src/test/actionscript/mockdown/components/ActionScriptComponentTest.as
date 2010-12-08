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
	public function constructorShouldCreateFunction():void
	{
		component = new ActionScriptComponent(null, TestComponent);
		var property:FunctionProperty = component.getProperty("functionProperty") as FunctionProperty;
		Assert.assertEquals("function", property.type);
		Assert.assertEquals("foo!", property.functionReference());
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

	[Function]
	public var functionProperty:Function = function():String{return "foo!"};
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
