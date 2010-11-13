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
	
	[Before]
	public function setup():void
	{
		mockupsDirectory = File.applicationDirectory.resolvePath("mockups");
		
		parser = new MockdownParser();
		parser.paths = [mockupsDirectory.nativePath];
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
	public function shouldParseComplexDocument():void
	{
		var root:Node = parser.parse("complex");

		// Verify root col
		Assert.assertTrue(root is Column);
		Assert.assertEquals(mockupsDirectory.resolvePath("complex.mkd").nativePath, root.document.filename);

		// Verify header
		var header:Object = root.children[0];
		Assert.assertTrue(header is Row);
		Assert.assertEquals("200", header.width);
		Assert.assertEquals('30', header.height);
		Assert.assertEquals('10', header.top);
		Assert.assertEquals(mockupsDirectory.resolvePath('header.mkx').nativePath, header.document.filename);
		Assert.assertEquals(2, header.children.length);

		var h2:Object   = header.children[0];
		var text:Object = header.children[1];
		Assert.assertTrue(h2 is Text);
		Assert.assertEquals("## Test Header", h2.content);
		Assert.assertTrue(text is Text);
		Assert.assertEquals("The header content.", text.content);
	}
}
}