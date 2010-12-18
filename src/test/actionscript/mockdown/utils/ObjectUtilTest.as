package mockdown.utils
{
import asunit.framework.Assert;

public class ObjectUtilTest
{
	//---------------------------------------------------------------------
	//
	//  Static Methods
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldDeepCopyObject():void
	{
		var a:Object = {x:{y:{z:12}}};
		var b:Object = ObjectUtil.copy(a);
		a.x.y.z = 50;
		Assert.assertEquals(12, b.x.y.z);
	}
}
}