package mockdown.parsers
{
import org.flexunit.Assert;

public class BlockParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var parser:BlockParser;
	
	[Before]
	public function setup():void
	{
		parser = new BlockParser();
	}

	private function assertBlock(parent:Block, level:int, lineNumber:int, content:String, childCount:int, block:Block):void
	{
		Assert.assertEquals("Block Parent", parent, block.parent);
		Assert.assertEquals("Block Level", level, block.level);
		Assert.assertEquals("Block Line#", lineNumber, block.lineNumber);
		Assert.assertEquals("Block Content", content, block.content);
		Assert.assertEquals("Block Child Count", childCount, block.children.length);
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Parsing
	//-----------------------------

	[Test]
	public function shouldEmptyContent():void
	{
	    var root:Block = parser.parse("");
	    assertBlock(null, 0, 0, null, 0, root);
	}
	
	[Test]
	public function shouldParseSingleLine():void
	{
	    var root:Block = parser.parse(
	      "%foo abc=123"
	    );
	    assertBlock(null, 0, 0, null, 1, root);
	    assertBlock(root, 1, 1, "%foo abc=123", 0, root.children[0]);
	}


	[Test]
	public function shouldParseNested():void
	{
		var root:Block = parser.parse(
			"%foo1\n" +
			"  %bar1\n" +
			"  %bar2\n" +
			"    %baz1\n" +
			"\n" +
			"    %baz2\n" +
			"\n" +
			"  %bar3\n" +
			"%foo2\n"
		);
    
		var foo1:Block = root.children[0];
		var foo2:Block = root.children[1];
		assertBlock(root, 1, 1, "%foo1", 3, foo1);
		assertBlock(root, 1, 9, "%foo2", 0, foo2);

		var bar1:Block = foo1.children[0];
		var bar2:Block = foo1.children[1];
		var bar3:Block = foo1.children[2];
		assertBlock(foo1, 2, 2, "%bar1", 0, bar1);
		assertBlock(foo1, 2, 3, "%bar2", 2, bar2);
		assertBlock(foo1, 2, 8, "%bar3", 0, bar3);

		var baz1:Block = bar2.children[0];
		var baz2:Block = bar2.children[1];
		assertBlock(bar2, 3, 4, "%baz1", 0, baz1);
		assertBlock(bar2, 3, 6, "%baz2", 0, baz2);
	}

	[Test]
	/**
	 *	Should join multiple lines together unless they start with a single
	 *	line character (% or !).
	 */
	public function shouldParseMultiline():void
	{
		var root:Block = parser.parse(
			"!pragma1\n" +
			"!pragma2\n" +
			"\n" +
			"%foo\n" +
			"  This is a test\n" +
			"  of a multiline\n" +
			"  block.\n" +
			"\n" +
			"  This is another \n" +
			"  block.\n" +
			"\n" +
			"  One more block\n" +
			"  %bar\n"
		);
    
		var pragma1:Block = root.children[0];
		var pragma2:Block = root.children[1];
		var foo:Block = root.children[2];
		assertBlock(root, 1, 1, '!pragma1', 0, pragma1);
		assertBlock(root, 1, 2, '!pragma2', 0, pragma2);
		assertBlock(root, 1, 4, '%foo', 4, foo);

		var b1:Block = foo.children[0];
		var b2:Block = foo.children[1];
		var b3:Block = foo.children[2];
		var bar:Block = foo.children[3];
		assertBlock(foo, 2, 5, "This is a test\nof a multiline\nblock.", 0, b1);
		assertBlock(foo, 2, 9, "This is another\nblock.", 0, b2);
		assertBlock(foo, 2, 12, "One more block", 0, b3);
		assertBlock(foo, 2, 13, "%bar", 0, bar);
	}
}
}