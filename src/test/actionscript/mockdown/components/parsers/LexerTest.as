package mockdown.components.parsers
{
import asunit.framework.Assert;

public class LexerTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var lexer:Lexer;
	

	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenInitializingNullString():void
	{
	    new Lexer(null);
	}
	
	[Test]
	public function shouldMatchPlainText():void
	{
		lexer = new Lexer("%abc test:123");
		Assert.assertEquals("%abc", lexer.match("%abc"));
		Assert.assertEquals(" ", lexer.match(/\s*/));
		Assert.assertEquals("test:123", lexer.match("test:123"));
	}

	[Test]
	public function shouldMatchRegExp():void
	{
		lexer = new Lexer("%abc test:123");
		Assert.assertEquals("abc", lexer.match(/%(\w+)\s*/));
		Assert.assertEquals("test:123", lexer.match(/\w+:\d+/));
	}

	[Test]
	public function shouldSkipNonMatch():void
	{
		lexer = new Lexer("abcdef");
		Assert.assertEquals("abc", lexer.match(/abc/));
		Assert.assertNull(lexer.match(/xyz/));
		Assert.assertEquals("def", lexer.match(/def/));
	}

	[Test]
	public function shouldCorrectlyReportEOF():void
	{
		lexer = new Lexer("ab");
		Assert.assertFalse(lexer.eof);
		lexer.match(/\w/);
		Assert.assertFalse(lexer.eof);
		lexer.match(/\w/);
		Assert.assertTrue(lexer.eof);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldErrorWhenPatternIsNull():void
	{
		(new Lexer("abc")).match(null);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldErrorWhenPatternIsGlobal():void
	{
		(new Lexer("abc")).match(/abc/g);
	}
}
}