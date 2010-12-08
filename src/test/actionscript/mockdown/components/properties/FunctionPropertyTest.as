package mockdown.components.properties
{
import mockdown.components.Component;

import asunit.framework.Assert;

public class FunctionPropertyTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var property:FunctionProperty;

	[Before]
	public function setup():void
	{
		property = new FunctionProperty();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------

	[Test]
	public function constructorShouldSetName():void
	{
		property = new FunctionProperty("foo");
		Assert.assertEquals("foo", property.name);
	}

	[Test]
	public function constructorShouldSetFunctionReference():void
	{
		property = new FunctionProperty("foo", function():String{return "bar"});
		Assert.assertEquals("bar", property.functionReference());
	}


	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------

	//---------------------------------
	//	Type
	//---------------------------------

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenSettingType():void
	{
		property.type = "foo";
	}

	//---------------------------------
	//	Function reference
	//---------------------------------

	[Test]
	public function shouldSetFunctionReference():void
	{
		var func:Function = function():void {}
		property.functionReference = func;
		Assert.assertEquals(func, property.functionReference);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingTypeWhenSealed():void
	{
		property.seal();
		property.functionReference = function():void{};
	}
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenParsing():void
	{
		property.parse("foo");
	}
}
}