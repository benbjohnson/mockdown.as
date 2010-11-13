package mockdown.parsers
{
import mockdown.data.*;

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
	

	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
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