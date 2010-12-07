package mockdown.components.properties
{
import mockdown.components.Component;

import asunit.framework.Assert;

public class BooleanPropertyTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var property:BooleanProperty;

	[Before]
	public function setup():void
	{
		property = new BooleanProperty();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------

	[Test]
	public function constructorShouldSetName():void
	{
		property = new BooleanProperty("foo");
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
	public function shouldParseTrueStringAsTrue():void
	{
		Assert.assertTrue(property.parse("true"));
	}

	[Test]
	public function shouldParseFalseStringAsFalse():void
	{
		Assert.assertFalse(property.parse("false"));
	}

	[Test]
	public function shouldParseNullIntoNull():void
	{
		Assert.assertNull(property.parse(null));
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorOnInvalidStringValues():void
	{
		Assert.assertFalse(property.parse("xyz"));
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorOnNonStringOrBooleanValues():void
	{
		Assert.assertFalse(property.parse(1));
	}
}
}