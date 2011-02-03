package mockdown.utils
{
import asunit.framework.Assert;

public class ParameterUtilTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var data:Object;
	
	[Before]
	public function setup():void
	{
		data = {};
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Static Methods
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldParseString():void
	{
		ParameterUtil.parse(data, "bar", "foo:string:1");
		Assert.assertEquals("bar", data.foo);
	}

	[Test]
	public function shouldParseInteger():void
	{
		ParameterUtil.parse(data, "12", "foo:int:1");
		Assert.assertEquals(12, data.foo);
	}

	[Test]
	public function shouldParseDecimal():void
	{
		ParameterUtil.parse(data, "12.1", "foo:decimal:1");
		Assert.assertEquals(12.1, data.foo);
	}
	
	[Test]
	public function shouldParseColor():void
	{
		ParameterUtil.parse(data, "#FF0000", "foo:color:1");
		Assert.assertEquals(0xFF0000, data.foo);
	}

	[Test]
	public function shouldParseArrayOfColors():void
	{
		ParameterUtil.parse(data, "#FF0000,#0000FF", "foo:color:*");
		Assert.assertTrue(data.foo is Array);
		Assert.assertEquals(2, data.foo.length);
		Assert.assertEquals(0xFF0000, data.foo[0]);
		Assert.assertEquals(0x0000FF, data.foo[1]);
	}
	
	[Test(expects="flash.errors.IllegalOperationError", message="Invalid parameter format: xyz")]
	public function shouldThrowErrorWhenParsingInvalidType():void
	{
		ParameterUtil.parse(data, "12.1", "foo:xyz:*");
	}
}
}