package mockdown.parsers.property
{
import org.flexunit.Assert;

public class BooleanPropertyParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var parser:BooleanPropertyParser;
	private var node:TestNode;
	
	[Before]
	public function setup():void
	{
		parser = new BooleanPropertyParser();
		node = new TestNode();
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldParseTrue():void
	{
		parser.parse(node, "booleanProperty", "true");
		Assert.assertTrue(node.booleanProperty);
	}

	[Test]
	public function shouldParseFalse():void
	{
		parser.parse(node, "booleanProperty", "false");
		Assert.assertFalse(node.booleanProperty);
	}

	[Test]
	public function shouldParseTrueToString():void
	{
		parser.parse(node, "stringProperty", "true");
		Assert.assertEquals("true", node.stringProperty);
	}

	[Test]
	public function shouldParseFalseToString():void
	{
		parser.parse(node, "stringProperty", "false");
		Assert.assertEquals("false", node.stringProperty);
	}

	[Test(expects="mockdown.errors.BlockParseError")]
	public function shouldErrorOnInvalidValue():void
	{
		parser.parse(node, "booleanProperty", "foo");
	}
}
}