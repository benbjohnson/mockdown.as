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
	
	//---------------------------------
	//	Parse
	//---------------------------------

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

	[Test(expects="ArgumentError", message="Value is not an integer: 'bar'")]
	public function shouldThrowErrorWhenParsingInvalidInteger():void
	{
		ParameterUtil.parse(data, "bar", "foo:int:1");
	}

	[Test]
	public function shouldParseDecimal():void
	{
		ParameterUtil.parse(data, "12.1", "foo:decimal:1");
		Assert.assertEquals(12.1, data.foo);
	}
	
	[Test(expects="ArgumentError", message="Value is not a decimal: 'bar'")]
	public function shouldThrowErrorWhenParsingInvalidDecimal():void
	{
		ParameterUtil.parse(data, "bar", "foo:decimal:1");
	}

	[Test]
	public function shouldParsePercent():void
	{
		ParameterUtil.parse(data, "50.25%", "foo:percent:1");
		Assert.assertEquals(50.25, data.foo);
	}
	
	[Test(expects="ArgumentError", message="Value is not a percentage: '20'")]
	public function shouldThrowErrorWhenParsingInvalidPercent():void
	{
		ParameterUtil.parse(data, "20", "foo:percent:1");
	}

	[Test]
	public function shouldParseLength():void
	{
		ParameterUtil.parse(data, "10px", "foo:length:1");
		Assert.assertEquals(10, data.foo);
	}
	
	[Test(expects="ArgumentError", message="Value is not a length: '20'")]
	public function shouldThrowErrorWhenParsingInvalidLength():void
	{
		ParameterUtil.parse(data, "20", "foo:length:1");
	}

	[Test]
	public function shouldParseColor():void
	{
		ParameterUtil.parse(data, "#FF0000", "foo:color:1");
		Assert.assertEquals(0xFF0000, data.foo);
	}

	[Test(expects="ArgumentError", message="Value is not a color: 'bar'")]
	public function shouldThrowErrorWhenParsingInvalidColor():void
	{
		ParameterUtil.parse(data, "bar", "foo:color:1");
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

	[Test]
	public function shouldParseMultiValue():void
	{
		ParameterUtil.parse(data, "2 #FF0000,#0000FF 50%,100%", "thickness:int:1 colors:color:* alphas:percent:*");
		Assert.assertEquals(2, data.thickness);
		Assert.assertEquals(2, data.colors.length);
		Assert.assertEquals(0xFF0000, data.colors[0]);
		Assert.assertEquals(0x0000FF, data.colors[1]);
		Assert.assertEquals(2, data.alphas.length);
		Assert.assertEquals(50, data.alphas[0]);
		Assert.assertEquals(100, data.alphas[1]);
	}
	
	[Test(expects="ArgumentError", message="Invalid parameter format: xyz")]
	public function shouldThrowErrorWhenParsingInvalidType():void
	{
		ParameterUtil.parse(data, "12.1", "foo:xyz:*");
	}


	//---------------------------------
	//	Format
	//---------------------------------

	[Test]
	public function shouldFormatString():void
	{
		data.foo = "bar";
		Assert.assertEquals("bar", ParameterUtil.format(data, "foo:string:1"));
	}

	[Test]
	public function shouldFormatInteger():void
	{
		data.foo = 12;
		Assert.assertEquals("12", ParameterUtil.format(data, "foo:int:1"));
	}

	[Test]
	public function shouldFormatDecimal():void
	{
		data.foo = 12.1;
		Assert.assertEquals("12.1", ParameterUtil.format(data, "foo:decimal:1"));
	}
	
	[Test]
	public function shouldFormatPercent():void
	{
		data.foo = 50.25;
		Assert.assertEquals("50.25%", ParameterUtil.format(data, "foo:percent:1"));
	}
	
	[Test]
	public function shouldFormatLength():void
	{
		data.foo = 10;
		Assert.assertEquals("10px", ParameterUtil.format(data, "foo:length:1"));
	}
	
	[Test]
	public function shouldFormatColor():void
	{
		data.foo = 0xFF0000;
		Assert.assertEquals("#FF0000", ParameterUtil.format(data, "foo:color:1"));
	}

	[Test]
	public function shouldFormatArrayOfColors():void
	{
		data.foo = [0xFF0000, 0x0000FF];
		Assert.assertEquals("#FF0000,#0000FF", ParameterUtil.format(data, "foo:color:*"));
	}

	[Test]
	public function shouldFormatMultiValue():void
	{
		data.thickness = 2;
		data.colors = [0xFF0000, 0x0000FF];
		data.alphas = [50, 100];
		Assert.assertEquals("2px #FF0000,#0000FF 50%,100%", ParameterUtil.format(data, "thickness:length:1 colors:color:* alphas:percent:*"));
	}
	
	[Test(expects="ArgumentError", message="Invalid parameter format: xyz")]
	public function shouldThrowErrorWhenFormattingInvalidType():void
	{
		data.foo = 12;
		ParameterUtil.format(data, "foo:xyz:1");
	}
}
}