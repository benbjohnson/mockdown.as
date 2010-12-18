package mockdown.core
{
import asunit.framework.Assert;

public class TypeTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var meta:Object;
	
	[Before]
	public function setup():void
	{
		meta = Type.describe(TestClass);
	}


	//---------------------------------------------------------------------
	//
	//  Static Methods
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Variables
	//---------------------------------

	[Test]
	public function shouldDescribeVariableName():void
	{
		Assert.assertEquals("stringVariable", meta.stringVariable.name);
	}

	[Test]
	public function shouldDescribeStringVariableType():void
	{
		Assert.assertEquals("string", meta.stringVariable.type);
	}

	[Test]
	public function shouldDescribeBooleanVariableType():void
	{
		Assert.assertEquals("boolean", meta.booleanVariable.type);
	}

	[Test]
	public function shouldDescribeIntVariableType():void
	{
		Assert.assertEquals("int", meta.intVariable.type);
	}

	[Test]
	public function shouldDescribeUIntVariableType():void
	{
		Assert.assertEquals("uint", meta.uintVariable.type);
	}

	[Test]
	public function shouldDescribeDecimalVariableType():void
	{
		Assert.assertEquals("decimal", meta.decimalVariable.type);
	}


	//---------------------------------
	//	Accessors/Mutators
	//---------------------------------

	[Test]
	public function accessToAccessorShouldBeReadble():void
	{
		Assert.assertTrue(meta.stringAccessor.access & Type.READABLE);
		Assert.assertFalse(meta.stringAccessor.access & Type.WRITABLE);
	}

	[Test]
	public function accessToMutatorShouldBeWritable():void
	{
		Assert.assertFalse(meta.stringMutator.access & Type.READABLE);
		Assert.assertTrue(meta.stringMutator.access & Type.WRITABLE);
	}

	[Test]
	public function accessToAccessorMutatorShouldBeReadWrite():void
	{
		Assert.assertTrue(meta.stringAccessorMutator.access & Type.READABLE);
		Assert.assertTrue(meta.stringAccessorMutator.access & Type.WRITABLE);
	}


	//---------------------------------
	//	Meta - Property type
	//---------------------------------

	[Test]
	public function shouldDescribeImplicitIntVariableType():void
	{
		Assert.assertEquals("int", meta.implicitIntVariable.type);
	}

	[Test]
	public function shouldDescribeImplicitUIntVariableType():void
	{
		Assert.assertEquals("uint", meta.implicitUIntVariable.type);
	}


	//---------------------------------
	//	Meta - Default value
	//---------------------------------

	[Test]
	public function shouldSetDefaultValue():void
	{
		Assert.assertEquals(100, meta.defaultValueVariable.defaultValue);
	}


	//---------------------------------
	//	Meta - Percent field
	//---------------------------------

	[Test]
	public function shouldSetPercentField():void
	{
		Assert.assertEquals("bar", meta.percentFieldVariable.percentField);
	}


	//---------------------------------
	//	Parse
	//---------------------------------

	[Test]
	public function shouldParseString():void
	{
		Assert.assertEquals("foo", Type.parse("foo", "string"));
	}

	[Test]
	public function shouldParseBooleanTrue():void
	{
		Assert.assertTrue(true, Type.parse("true", "boolean"));
	}

	[Test]
	public function shouldParseBooleanFalse():void
	{
		Assert.assertFalse(Type.parse("false", "boolean"));
	}

	[Test]
	public function shouldParseInt():void
	{
		Assert.assertEquals(12, Type.parse("12", "int"));
	}

	[Test]
	public function shouldParseUInt():void
	{
		Assert.assertEquals(100, Type.parse("100", "uint"));
	}
	
	[Test]
	public function shouldParseNegativeToUInt():void
	{
		Assert.assertEquals(0, Type.parse("-12", "uint"));
	}

	[Test]
	public function shouldParseDecimal():void
	{
		Assert.assertEquals(20.1, Type.parse("20.1", "decimal"));
	}

	[Test]
	public function shouldParseNaNToDecimal():void
	{
		Assert.assertNull(Type.parse("not_a_number", "decimal"));
	}
}
}

class TestClass
{
	public var stringVariable:String;
	public var booleanVariable:Boolean;
	public var intVariable:int;
	public var uintVariable:uint;
	public var decimalVariable:Number;

	[Property(type="int")]
	public var implicitIntVariable:Number;

	[Property(type="uint")]
	public var implicitUIntVariable:*;

	[Property(defaultValue="100")]
	public var defaultValueVariable:int;

	[Property(percentField="bar")]
	public var percentFieldVariable:String;

	public function get stringAccessor():String {return ""}
	public function set stringMutator(value:String):void {}

	public function get stringAccessorMutator():String {return ""}
	public function set stringAccessorMutator(value:String):void {}
}