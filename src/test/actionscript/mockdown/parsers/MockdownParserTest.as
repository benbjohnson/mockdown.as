package mockdown.parsers
{
import mockdown.components.*;
import mockdown.core.Document;

import org.flexunit.Assert;

import flash.filesystem.File;

public class MockdownParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var parser:MockdownParser;

	private var mockupsDirectory:File;
	private var libDirectory:File;
	private var lib2Directory:File;
	
	[Before]
	public function setup():void
	{
		mockupsDirectory = File.applicationDirectory.resolvePath("mockups");
		libDirectory = mockupsDirectory.resolvePath("lib");
		lib2Directory = mockupsDirectory.resolvePath("lib2");
		
		parser = new MockdownParser();
		parser.paths = [libDirectory.nativePath, mockupsDirectory.nativePath];
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
	
	//---------------------------------
	//	Block preprocessing
	//---------------------------------
	
	[Test]
	public function shouldCreateEmptyContent():void
	{
	    var root:Block = parser.createBlockTree("");
	    assertBlock(null, 0, 0, null, 0, root);
	}
	
	[Test]
	public function shouldCreateBlockTreeForSingleLine():void
	{
	    var root:Block = parser.createBlockTree(
	      "%foo abc=123"
	    );
	    assertBlock(null, 0, 0, null, 1, root);
	    assertBlock(root, 1, 1, "%foo abc=123", 0, root.children[0]);
	}


	[Test]
	public function shouldCreateBlockTreeNested():void
	{
		var root:Block = parser.createBlockTree(
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
	public function shouldCreateBlockTreeMultiline():void
	{
		var root:Block = parser.createBlockTree(
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


	//---------------------------------
	//	Document parsing
	//---------------------------------
	
	[Test]
	public function shouldParseBlankContentAsNull():void
	{
	    Assert.assertNull(parser.parse("empty"));
	}

	[Test]
	public function shouldParseSimpleDocument():void
	{
		var root:Node = parser.parse("simple");
		
	    // Verify root col
	    Assert.assertTrue(root is Column);
	    Assert.assertEquals(3, root.children.length);
	    Assert.assertTrue(root.document is Document)
	    Assert.assertEquals(mockupsDirectory.resolvePath("simple.mkd").nativePath, root.document.filename);
    
	    // Verify all children of the column
		var text:Object = root.children[0];
		var h2:Object   = root.children[1];
		var p:Object    = root.children[2];
	    Assert.assertTrue(text is Text);
	    Assert.assertEquals('Welcome to Nevada!', text.content);
	    Assert.assertEquals(root.document, text.document);
	    Assert.assertTrue(h2 is Text);
	    Assert.assertEquals('## Las Vegas', h2.content);
	    Assert.assertEquals(root.document, h2.document);
	    Assert.assertTrue(p is Text);
	    Assert.assertEquals('Please spend all your money here.', p.content);
	    Assert.assertEquals(root.document, p.document);
	}

	[Test]
	public function shouldSearchLoadPathInOrder():void
	{
		parser.paths = [lib2Directory.nativePath].concat(parser.paths);
		var root:Node = parser.parse("load_paths");

		// Verify object
		var foo:Object = root.children[0];
		Assert.assertEquals("2", foo.width);
	}

	[Test]
	public function shouldFindComponentsWithinDirectories():void
	{
		var root:Node = parser.parse("dirs");

		// Verify object
		var node:Object = root.children[0];
	    Assert.assertEquals(mockupsDirectory.resolvePath("subdir/bar.mkx").nativePath, node.document.filename);
	}
}
}