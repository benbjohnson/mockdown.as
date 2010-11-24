package mockdown.utils
{
import org.flexunit.Assert;

public class StringUtilTest
{
	//---------------------------------------------------------------------
	//
	//  Static Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Trim
	//-----------------------------

	[Test]
	public function shouldTrim():void
	{
		Assert.assertEquals("a bc", StringUtil.trim(" \t\n\ra bc\t \n \r  "));
	}

	[Test]
	public function shouldLTrim():void
	{
		Assert.assertEquals("a bc\t \n \r  ", StringUtil.ltrim(" \t\n\ra bc\t \n \r  "));
	}

	[Test]
	public function shouldRTrim():void
	{
		Assert.assertEquals(" \t\n\ra bc", StringUtil.rtrim(" \t\n\ra bc\t \n \r  "));
	}


	//-----------------------------
	//  Parsing
	//-----------------------------

	[Test]
	public function shouldParseNumber():void
	{
		Assert.assertEquals(12, StringUtil.parseNumber("12"));
		Assert.assertEquals(-5, StringUtil.parseNumber("-5"));
		Assert.assertEquals(101.34, StringUtil.parseNumber("101.34"));
		Assert.assertEquals(-23.02, StringUtil.parseNumber("-23.02"));
	}

	[Test]
	public function shouldNotParseInvalidInteger():void
	{
		Assert.assertTrue(isNaN(StringUtil.parseNumber("1x34")));
		Assert.assertTrue(isNaN(StringUtil.parseNumber("")));
		Assert.assertTrue(isNaN(StringUtil.parseNumber(null)));
	}

	[Test]
	public function shouldParsePercentage():void
	{
		Assert.assertEquals(20, StringUtil.parsePercentage("20%"));
		Assert.assertEquals(5.21, StringUtil.parsePercentage("5.21%"));
		Assert.assertEquals(-20, StringUtil.parsePercentage("-20%"));
		Assert.assertEquals(-5.21, StringUtil.parsePercentage("-5.21%"));
	}

	[Test]
	public function shouldNotParseInvalidPercentage():void
	{
		Assert.assertTrue(isNaN(StringUtil.parsePercentage("1x34")));
		Assert.assertTrue(isNaN(StringUtil.parsePercentage("")));
		Assert.assertTrue(isNaN(StringUtil.parsePercentage(null)));
	}

	[Test]
	public function shouldShowNullAsEmpty():void
	{
		Assert.assertTrue(StringUtil.isEmpty(null));
	}

	[Test]
	public function shouldShowBlankStringAsEmpty():void
	{
		Assert.assertTrue(StringUtil.isEmpty(""));
	}

	[Test]
	public function shouldNotShowNonBlankStringAsEmpty():void
	{
		Assert.assertFalse(StringUtil.isEmpty("foo"));
	}
}
}