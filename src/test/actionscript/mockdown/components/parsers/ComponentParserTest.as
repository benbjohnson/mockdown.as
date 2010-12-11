package mockdown.components.parsers
{
import mockdown.components.Component;
import mockdown.components.NodeDescriptor;
import mockdown.components.properties.*;
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
	private var foo:Component;
	private var loader:MockComponentLoader;
	
	[Before]
	public function setup():void
	{
		parser = new ComponentParser();

		foo = new Component();
		foo.addProperty(new StringProperty("bar"))
		foo.addProperty(new BooleanProperty("bool"))
		loader = new MockComponentLoader();
		parser.loader = loader;
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Parse (Pragma:Var)
	//-----------------------------

	[Test]
	public function shouldAddStringProperty():void
	{
		var component:Component = parser.parse("!var myProperty:string");
		Assert.assertEquals("string", component.getProperty("myProperty").type);
	}

	[Test]
	public function shouldAddImplicitStringProperty():void
	{
		var component:Component = parser.parse("!var myProperty");
		Assert.assertEquals("string", component.getProperty("myProperty").type);
	}

	[Test]
	public function shouldAddIntProperty():void
	{
		var component:Component = parser.parse("!var myProperty:int");
		Assert.assertEquals("int", component.getProperty("myProperty").type);
	}

	[Test]
	public function shouldAddUIntProperty():void
	{
		var component:Component = parser.parse("!var myProperty:uint");
		Assert.assertEquals("uint", component.getProperty("myProperty").type);
	}

	[Test]
	public function shouldAddDecimalProperty():void
	{
		var component:Component = parser.parse("!var myProperty:decimal");
		Assert.assertEquals("decimal", component.getProperty("myProperty").type);
	}

	[Test]
	public function shouldAddBooleanProperty():void
	{
		var component:Component = parser.parse("!var myProperty:boolean");
		Assert.assertEquals("boolean", component.getProperty("myProperty").type);
	}


	[Test]
	public function shouldSetPropertyOptions():void
	{
		var component:Component = parser.parse("!var myProperty:decimal (allowNegative=\"false\", percentField=\"foo\", defaultValue=\"100\", nullable=\"false\")");
		var property:NumberProperty = component.getProperty("myProperty") as NumberProperty;
		Assert.assertEquals("decimal", property.type);
		Assert.assertFalse(property.allowNegative);
		Assert.assertEquals("foo", property.percentField);
		Assert.assertEquals(100, property.defaultValue);
		Assert.assertFalse(property.nullable);
	}

	[Test]
	public function shouldThrowErrorForMissingPropertyName():void
	{
		assertThrowsWithMessage(BlockParseError, "Expected property name", function():void{
			parser.parse("!var");
		});
	}

	[Test]
	public function shouldThrowErrorForInvalidPropertyType():void
	{
		assertThrowsWithMessage(BlockParseError, "Invalid property type: foo", function():void{
			parser.parse("!var xyz:foo");
		});
	}

	[Test]
	public function shouldThrowErrorForMissingPropertyOptionName():void
	{
		assertThrowsWithMessage(BlockParseError, "Expected property option name", function():void{
			parser.parse("!var xyz (!)");
		});
	}

	[Test]
	public function shouldThrowErrorForMissingPropertyOptionKeyValueSeparator():void
	{
		assertThrowsWithMessage(BlockParseError, "Expected '='", function():void{
			parser.parse("!var xyz (foo)");
		});
	}

	[Test]
	public function shouldThrowErrorForMissingInvalidPropertyOptionValueFormat():void
	{
		assertThrowsWithMessage(BlockParseError, "Expected \"<value>\" for option: foo", function():void{
			parser.parse("!var xyz (foo=bar)");
		});
	}

	[Test]
	public function shouldThrowErrorForDuplicatePropertyOptionKeys():void
	{
		assertThrowsWithMessage(BlockParseError, "Property option already defined: foo", function():void{
			parser.parse("!var xyz (foo=\"bar\", foo=\"baz\")");
		});
	}


	//-----------------------------
	//  Parse (Pragma:Import)
	//-----------------------------

	[Test]
	public function shouldAddLibrary():void
	{
		loader.expects("addLibrary").withArgs("foo");
		parser.parse("!import foo");
		Assert.assertTrue(loader.errorMessage(), loader.success());
	}

	[Test]
	public function shouldThrowErrorForMissingImportLibraryName():void
	{
		assertThrowsWithMessage(BlockParseError, "Expected library name for import", function():void{
			parser.parse("!import");
		});
	}


	//-----------------------------
	//  Parse (Node Descriptors)
	//-----------------------------

	[Test]
	public function shouldAddNodeDescriptor():void
	{
		loader.expects("find").withArgs("foo").willReturn(foo);
		var component:Component = parser.parse("%foo");

		Assert.assertTrue(loader.errorMessage(), loader.success());
		Assert.assertNotNull(component.descriptor);
		Assert.assertEquals(component, component.descriptor.component);
	}

	[Test]
	public function shouldAddNodeDescriptorTree():void
	{
		loader.expects("find").withArgs("foo").willReturn(foo);
		loader.expects("find").withArgs("foo").willReturn(foo);
		loader.expects("find").withArgs("foo").willReturn(foo);
		loader.expects("find").withArgs("foo").willReturn(foo);
		loader.expects("find").withArgs("foo").willReturn(foo);
		var component:Component = parser.parse(
			"%foo bar=root\n" +			// root
			"  %foo bar=\"a\"\n" +		// a
			"    %foo bar='aa'\n" +		// aa
			"\n" +
			"    %foo bar=ab bool\n" +	// ab
			"\n" +
			"  %foo !bool\n"			// b
		);

		Assert.assertTrue(loader.errorMessage(), loader.success());

		var root:NodeDescriptor = component.descriptor;
		Assert.assertNotNull(root);
		Assert.assertEquals(component, root.component);
		Assert.assertEquals("root", root.getPropertyValue("bar"));
		Assert.assertNull(root.parent);
		Assert.assertEquals(2, root.children.length);
		
		var a:NodeDescriptor = root.children[0];
		Assert.assertEquals(foo, a.component);
		Assert.assertEquals("a", a.getPropertyValue("bar"));
		Assert.assertEquals(root, a.parent);
		Assert.assertEquals(2, a.children.length);

		var aa:NodeDescriptor = a.children[0];
		Assert.assertEquals(foo, aa.component);
		Assert.assertEquals("aa", aa.getPropertyValue("bar"));
		Assert.assertEquals(a, aa.parent);
		Assert.assertEquals(0, aa.children.length);

		var ab:NodeDescriptor = a.children[1];
		Assert.assertEquals(foo, ab.component);
		Assert.assertEquals("ab", ab.getPropertyValue("bar"));
		Assert.assertEquals("true", ab.getPropertyValue("bool"));
		Assert.assertEquals(a, ab.parent);
		Assert.assertEquals(0, ab.children.length);

		var b:NodeDescriptor = root.children[1];
		Assert.assertEquals(foo, b.component);
		Assert.assertNull(b.getPropertyValue("bar"));
		Assert.assertEquals("false", b.getPropertyValue("bool"));
		Assert.assertEquals(root, b.parent);
		Assert.assertEquals(0, b.children.length);
	}

	[Test]
	public function shouldThrowErrorForMissingComponentName():void
	{
		assertThrowsWithMessage(BlockParseError, "Expected component name", function():void{
			parser.parse("% foo=bar");
		});
	}

	[Test]
	public function shouldThrowErrorIfComponentCannotBeLoaded():void
	{
		var loader:MockComponentLoader = new MockComponentLoader();
		loader.expects("find").withArgs("foo").willReturn(null);

		assertThrowsWithMessage(BlockParseError, "Component not found: foo", function():void{
			parser.parse("%foo");
		});
	}


	[Test]
	public function shouldAddNodeDescriptorWithUnquotedProperty():void
	{
		loader.expects("find").withArgs("foo").willReturn(foo);
		var component:Component = parser.parse("%foo bar=baz");

		Assert.assertTrue(loader.errorMessage(), loader.success());
		Assert.assertEquals("baz", component.descriptor.getPropertyValue("bar"));
	}

	[Test]
	public function shouldAddNodeDescriptorWithSingleQuotedProperty():void
	{
		loader.expects("find").withArgs("foo").willReturn(foo);
		var component:Component = parser.parse("%foo bar='baz bat'");

		Assert.assertTrue(loader.errorMessage(), loader.success());
		Assert.assertEquals("baz bat", component.descriptor.getPropertyValue("bar"));
	}

	[Test]
	public function shouldAddNodeDescriptorWithDoubleQuotedProperty():void
	{
		loader.expects("find").withArgs("foo").willReturn(foo);
		var component:Component = parser.parse('%foo bar="baz bat"');

		Assert.assertTrue(loader.errorMessage(), loader.success());
		Assert.assertEquals("baz bat", component.descriptor.getPropertyValue("bar"));
	}

	[Test]
	public function shouldAddNodeDescriptorWithTrueBooleanPropertyValue():void
	{
		loader.expects("find").withArgs("foo").willReturn(foo);
		var component:Component = parser.parse("%foo bool");

		Assert.assertTrue(loader.errorMessage(), loader.success());
		Assert.assertEquals("true", component.descriptor.getPropertyValue("bool"));
	}

	[Test]
	public function shouldAddNodeDescriptorWithFalseBooleanPropertyValue():void
	{
		loader.expects("find").withArgs("foo").willReturn(foo);
		var component:Component = parser.parse("%foo !bool");

		Assert.assertTrue(loader.errorMessage(), loader.success());
		Assert.assertEquals("false", component.descriptor.getPropertyValue("bool"));
	}

	[Test]
	public function shouldThrowErrorIfBooleanValueImplicitlySetForNonBooleanProperty():void
	{
		loader.expects("find").withArgs("foo").willReturn(foo);
		assertThrowsWithMessage(BlockParseError, "A value is required for non-boolean property: bar", function():void{
			parser.parse("%foo bar");
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
	public function find(name:String):Component {
		record("find", name);
		return expectedReturnFor("find") as Component;
	}
	public function newInstance(name:String):Node {
		record("newInstance", name);
		return expectedReturnFor("newInstance") as Node;
	}
	public function addLibrary(name:String):void {
		record("addLibrary", name);
	}
}