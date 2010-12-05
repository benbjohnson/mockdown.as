package mockdown.parsers.property
{
import org.flexunit.Assert;

public class StringPropertyParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var parser:StringPropertyParser;
	private var node:TestNode;
	
	[Before]
	public function setup():void
	{
		parser = new StringPropertyParser();
		node = new TestNode();
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldParseString():void
	{
		parser.parse(node, "stringProperty", "foo");
		Assert.assertEquals("foo", node.stringProperty);
	}
}
}