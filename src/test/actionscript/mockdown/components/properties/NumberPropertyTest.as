package mockdown.components.properties
{
import mockdown.components.Component;

import asunit.framework.Assert;

public class NumberPropertyTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var property:NumberProperty;

	[Before]
	public function setup():void
	{
		property = new NumberProperty();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------

	[Test]
	public function constructorShouldSetName():void
	{
		property = new NumberProperty("foo");
		Assert.assertEquals("foo", property.name);
	}

	[Test]
	public function constructorShouldSetType():void
	{
		property = new NumberProperty("foo", "decimal");
		Assert.assertEquals("decimal", property.type);
	}


	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------

	//---------------------------------
	//	Type
	//---------------------------------

	[Test]
	public function shouldSetAllowedType():void
	{
		property.type = "int";
		property.type = "uint";
		property.type = "decimal";
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorWhenSettingUnallowedType():void
	{
		property.type = "foo";
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingTypeWhenSealed():void
	{
		property.seal();
		property.type = "int";
	}
	[Test]
	public function shouldImplicitlyNotAllowNegativesForUInt():void
	{
		property.allowNegative = true;
		property.type = "uint";
		Assert.assertFalse(property.allowNegative);
	}
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldParseStringIntoInteger():void
	{
		property.type = "int";
		Assert.assertEquals(100, property.parse("100"));
	}

	[Test]
	public function shouldParseStringIntoNegativeInteger():void
	{
		property.type = "int";
		Assert.assertEquals(-12, property.parse("-12"));
	}

	[Test]
	public function shouldParseStringIntoNegativeDecimal():void
	{
		property.type = "decimal";
		Assert.assertEquals(-12.203, property.parse("-12.203"));
	}

	[Test]
	public function shouldParseStringDecimalIntoInteger():void
	{
		property.type = "int";
		Assert.assertEquals(100, property.parse("100.2"));
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorWhenParsingNonNumericValue():void
	{
		property.type = "int";
		property.parse("xyz");
	}


	[Test]
	public function shouldParseDecimalToInt():void
	{
		property.type = "int";
		Assert.assertEquals(20, property.parse(20.7));
	}

	[Test]
	public function shouldParseDecimalToUInt():void
	{
		property.type = "uint";
		Assert.assertEquals(0, property.parse(-20.7));
	}

	[Test]
	public function shouldParseDecimalToDecimal():void
	{
		property.type = "decimal";
		Assert.assertEquals(-20.7, property.parse(-20.7));
	}


	[Test]
	public function shouldParseNullToNull():void
	{
		property.type = "int";
		Assert.assertNull(property.parse(null));
	}
}
}