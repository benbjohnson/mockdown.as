package mockdown.display
{
import asunit.framework.Assert;

public class ColorTest
{
	//---------------------------------------------------------------------
	//
	//  Static Methods
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldConvertRGBToHex():void
	{
		Assert.assertEquals("FF0000", Color.toHex(16711680));
	}
	
	[Test]
	public function shouldConvertHexToRGB():void
	{
		Assert.assertEquals(16711680, Color.fromHex("FF0000"));
	}
}
}
