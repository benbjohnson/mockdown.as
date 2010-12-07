package mockdown.components.properties
{
import mockdown.components.Component;

import asunit.framework.Assert;

public class StringPropertyTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var property:StringProperty;

	[Before]
	public function setup():void
	{
		property = new StringProperty();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------

	[Test]
	public function constructorShouldSetName():void
	{
		property = new StringProperty("foo");
		Assert.assertEquals("foo", property.name);
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

	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldParseStringAsOriginalValue():void
	{
		Assert.assertEquals("foo", property.parse("foo"));
	}

	[Test]
	public function shouldParseNonStringValueIntoString():void
	{
		Assert.assertEquals("12", property.parse(12));
	}

	[Test]
	public function shouldParseNullIntoNull():void
	{
		Assert.assertEquals("foo", property.parse("foo"));
	}
}
}