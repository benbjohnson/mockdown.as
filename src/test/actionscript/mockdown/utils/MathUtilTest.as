package mockdown.utils
{
import asunit.framework.Assert;

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
		Assert.assertEquals(12, MathUtil.restrict(5, 12, 20));
	}

	[Test]
	public function shouldRestrictMaxValue():void
	{
		Assert.assertEquals(50, MathUtil.restrict(100, 12, 50));
	}

	[Test]
	public function shouldNotRestrictMaxValueWhenNaN():void
	{
		Assert.assertEquals(200, MathUtil.restrict(200, 12, NaN));
	}

	[Test]
	public function shouldNotRestrictMinValueWhenNaN():void
	{
		Assert.assertEquals(-20, MathUtil.restrict(-20, NaN, 100));
	}
}
}