package mockdown.components.parsers
{
import mockdown.components.Column;
import mockdown.components.Component;
import mockdown.components.ComponentDescriptor;
import mockdown.components.Row;
import mockdown.errors.BlockParseError;
import mockdown.test.*;

import asunit.framework.Assert;

public class ComponentParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var parser:ComponentParser;
	private var loader:MockComponentLoader;
	
	[Before]
	public function setup():void
	{
		parser = new ComponentParser();

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
		assertThrowsWithMessage(BlockParseError, "Expected: key name", function():void{
			parser.parse("%col =bar");
		});
	}
}
}


//-----------------------------------------------------------------------------
//
//  Mocks
//
//-----------------------------------------------------------------------------

import mockdown.components.*;
import mockdown.components.loaders.*;
import org.mock4as.Mock;
class MockComponentLoader extends Mock implements ComponentLoader {
	public function find(name:String):* {
		record("find", name);
		return expectedReturnFor("find");
	}
	public function newInstance(name:String):Component {
		record("newInstance", name);
		return expectedReturnFor("newInstance") as Component;
	}
	public function addLibrary(name:String):void {
		record("addLibrary", name);
	}
}