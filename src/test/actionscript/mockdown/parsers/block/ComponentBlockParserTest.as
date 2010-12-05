package mockdown.parsers.block
{
import org.flexunit.Assert;

public class ComponentBlockParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var parser:ComponentBlockParser;
	
	[Before]
	public function setup():void
	{
		parser = new ComponentBlockParser();
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function should():void
	{
		parser.parse(node, "stringProperty", "foo");
		Assert.assertEquals("foo", node.stringProperty);
	}
}
}