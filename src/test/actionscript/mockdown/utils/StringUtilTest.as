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
}
}