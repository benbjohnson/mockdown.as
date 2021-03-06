package mockdown.components.parsers
{
import mockdown.components.Column;
import mockdown.components.BaseComponent;
import mockdown.components.ComponentDescriptor;
import mockdown.components.Row;
import mockdown.components.loaders.MockComponentLoader;
import mockdown.errors.BlockParseError;

import asunit.framework.Assert;

import flash.utils.describeType;

public class DefaultComponentParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var parser:DefaultComponentParser;
	private var loader:MockComponentLoader;
	
	[Before]
	public function setup():void
	{
		parser = new DefaultComponentParser();

		loader = new MockComponentLoader();
		parser.loader = loader;
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Parse (Descriptors)
	//-----------------------------

	[Test]
	public function shouldAddComponentDescriptor():void
	{
		loader.expects("find").withArgs("col").willReturn(Column);
		var descriptor:ComponentDescriptor = parser.parse("%col");

		Assert.assertTrue(loader.errorMessage(), loader.success());
		Assert.assertNotNull(descriptor);
		Assert.assertEquals(Column, descriptor.parent);
	}

	[Test]
	public function shouldAddComponentDescriptorTree():void
	{
		loader.expects("find").withArgs("col").willReturn(Column);
		loader.expects("find").withArgs("row").willReturn(Row);
		loader.expects("find").withArgs("row").willReturn(Row);
		loader.expects("find").withArgs("col").willReturn(Column);
		var descriptor:ComponentDescriptor = parser.parse(
			"%col\n" +
			"  %row\n" +
			"\n" +
			"  %row\n" +
			"    %col"
		);

		Assert.assertTrue(loader.errorMessage(), loader.success());
		Assert.assertEquals(Column, descriptor.parent);
		Assert.assertEquals(Row, descriptor.children[0].parent);
		Assert.assertEquals(Row, descriptor.children[1].parent);
		Assert.assertEquals(Column, descriptor.children[1].children[0].parent);
	}

	[Test(expects="mockdown.errors.BlockParseError", message="Expected component name")]
	public function shouldThrowErrorForMissingComponentName():void
	{
		parser.parse("%");
	}

	[Test(expects="mockdown.errors.BlockParseError", message="BaseComponent not found: foo")]
	public function shouldThrowErrorForMissingComponent():void
	{
		parser.parse("%foo");
	}

	//-----------------------------
	//  Parse (Properties)
	//-----------------------------

	[Test]
	public function shouldParseStringVariable():void
	{
		loader.expects("find").withArgs("test").willReturn(TestComponent);
		var descriptor:ComponentDescriptor = parser.parse("%test stringVariable=foo");
		Assert.assertEquals("foo", descriptor.values.stringVariable);
	}

	[Test]
	public function shouldParseBooleanTrueVariable():void
	{
		loader.expects("find").withArgs("test").willReturn(TestComponent);
		var descriptor:ComponentDescriptor = parser.parse("%test booleanVariable=true");
		Assert.assertEquals(true, descriptor.values.booleanVariable);
	}

	[Test]
	public function shouldParseBooleanFalseVariable():void
	{
		loader.expects("find").withArgs("test").willReturn(TestComponent);
		var descriptor:ComponentDescriptor = parser.parse("%test booleanVariable=false");
		Assert.assertEquals(false, descriptor.values.booleanVariable);
	}

	[Test]
	public function shouldParseIntVariable():void
	{
		loader.expects("find").withArgs("test").willReturn(TestComponent);
		var descriptor:ComponentDescriptor = parser.parse("%test intVariable=12");
		Assert.assertEquals(12, descriptor.values.intVariable);
	}

	[Test]
	public function shouldParseUIntVariable():void
	{
		loader.expects("find").withArgs("test").willReturn(TestComponent);
		var descriptor:ComponentDescriptor = parser.parse("%test uintVariable=12");
		Assert.assertEquals(12, descriptor.values.uintVariable);
	}

	[Test]
	public function shouldParseDecimalVariable():void
	{
		loader.expects("find").withArgs("test").willReturn(TestComponent);
		var descriptor:ComponentDescriptor = parser.parse("%test decimalVariable=100.23");
		Assert.assertEquals(100.23, descriptor.values.decimalVariable);
	}

	[Test]
	public function shouldParseUnquotedProperty():void
	{
		loader.expects("find").withArgs("col").willReturn(Column);
		var descriptor:ComponentDescriptor = parser.parse("%col align=center");
		Assert.assertEquals("center", descriptor.values.align);
	}

	[Test]
	public function shouldParseSingleQuotedProperty():void
	{
		loader.expects("find").withArgs("col").willReturn(Column);
		var descriptor:ComponentDescriptor = parser.parse("%col align='center'");
		Assert.assertEquals("center", descriptor.values.align);
	}

	[Test]
	public function shouldParseDoubleQuotedProperty():void
	{
		loader.expects("find").withArgs("col").willReturn(Column);
		var descriptor:ComponentDescriptor = parser.parse("%col align=\"center\"");
		Assert.assertEquals("center", descriptor.values.align);
	}

	[Test(expects="mockdown.errors.BlockParseError", message="Expected key name")]
	public function shouldThrowErrorWhenMissingPropertyKey():void
	{
		loader.expects("find").withArgs("col").willReturn(Column);
		parser.parse("%col =bar");
	}
	
	[Test]
	public function shouldParsePercentWidth():void
	{
		loader.expects("find").withArgs("test").willReturn(TestComponent);
		var descriptor:ComponentDescriptor = parser.parse("%test width=20%");
		Assert.assertEquals(20, descriptor.values.percentWidth);
	}

	[Test(expects="mockdown.errors.BlockParseError", message="Property doesn't exist: foo")]
	public function shouldThrowErrorWhenMissingProperty():void
	{
		loader.expects("find").withArgs("col").willReturn(Column);
		parser.parse("%col foo=bar");
	}
}
}


//-----------------------------------------------------------------------------
//
//  Internal Classes
//
//-----------------------------------------------------------------------------

import mockdown.components.BaseComponent;
class TestComponent extends BaseComponent
{
	public var stringVariable:String;
	public var booleanVariable:Boolean;
	public var intVariable:int;
	public var uintVariable:uint;
	public var decimalVariable:Number;
}