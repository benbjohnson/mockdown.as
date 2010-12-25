package mockdown.components.parsers
{
import mockdown.components.Column;
import mockdown.components.Component;
import mockdown.components.ComponentDescriptor;
import mockdown.components.Row;
import mockdown.components.loaders.MockComponentLoader;
import mockdown.errors.BlockParseError;
import mockdown.test.*;

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

	[Test]
	public function shouldThrowErrorForMissingComponentName():void
	{
		assertThrowsWithMessage(BlockParseError, "Expected component name", function():void{
			parser.parse("%");
		});
	}

	[Test]
	public function shouldThrowErrorForMissingComponent():void
	{
		assertThrowsWithMessage(BlockParseError, "Component not found: foo", function():void{
			parser.parse("%foo");
		});
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

	[Test]
	public function shouldThrowErrorWhenMissingPropertyKey():void
	{
		loader.expects("find").withArgs("col").willReturn(Column);
		assertThrowsWithMessage(BlockParseError, "Expected key name", function():void{
			parser.parse("%col =bar");
		});
	}
	
	[Test]
	public function shouldParsePercentWidth():void
	{
		loader.expects("find").withArgs("test").willReturn(TestComponent);
		var descriptor:ComponentDescriptor = parser.parse("%test width=20%");
		Assert.assertEquals(20, descriptor.values.percentWidth);
	}

	[Test]
	public function shouldThrowErrorWhenMissingProperty():void
	{
		loader.expects("find").withArgs("col").willReturn(Column);
		assertThrowsWithMessage(BlockParseError, "Property doesn't exist: foo", function():void{
			parser.parse("%col foo=bar");
		});
	}
}
}


//-----------------------------------------------------------------------------
//
//  Internal Classes
//
//-----------------------------------------------------------------------------

import mockdown.components.Component;
class TestComponent extends Component
{
	public var stringVariable:String;
	public var booleanVariable:Boolean;
	public var intVariable:int;
	public var uintVariable:uint;
	public var decimalVariable:Number;
}