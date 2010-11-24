package mockdown.utils
{
import org.flexunit.Assert;

public class MathUtilTest
{
	//---------------------------------------------------------------------
	//
	//  Static Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Restrict
	//-----------------------------

	[Test]
	public function shouldRestrictMinValue():void
	{
		Assert.assertEquals(12, MathUtil.restrictUInt(5, 12, 20));
	}

	[Test]
	public function shouldRestrictMaxValue():void
	{
		Assert.assertEquals(50, MathUtil.restrictUInt(100, 12, 50));
	}

	[Test]
	public function shouldNotRestrictMaxValueWhenZero():void
	{
		Assert.assertEquals(200, MathUtil.restrictUInt(200, 12, 0));
	}
}
}