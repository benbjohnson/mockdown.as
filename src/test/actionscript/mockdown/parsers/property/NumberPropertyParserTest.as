package mockdown.parsers.property
{
import org.flexunit.Assert;

public class NumberPropertyParserTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var parser:NumberPropertyParser;
	private var node:TestNode;
	
	[Before]
	public function setup():void
	{
		parser = new NumberPropertyParser();
		node = new TestNode();
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Data types
	//---------------------------------

	[Test]
	public function shouldParseInteger():void
	{
		parser.parse(node, "integerProperty", "12");
		Assert.assertEquals(12, node.integerProperty);
	}

	[Test]
	public function shouldParseDecimal():void
	{
		parser.parse(node, "decimalProperty", "-100.25");
		Assert.assertEquals(-100.25, node.decimalProperty);
	}

	[Test(expects="ArgumentError")]
	public function shouldErrorOnUnknownType():void
	{
		parser.parse(node, "stringProperty", "-100.25");
		Assert.assertEquals(-100.25, node.stringProperty);
	}

	//---------------------------------
	//	Allow negative
	//---------------------------------

	[Test]
	public function shouldParseImplicitNegative():void
	{
		parser.parse(node, "implicitNegativeProperty", "-12");
		Assert.assertEquals(-12, node.implicitNegativeProperty);
	}

	[Test]
	public function shouldParseExplicitNegative():void
	{
		parser.parse(node, "explicitNegativeProperty", "-12");
		Assert.assertEquals(-12, node.explicitNegativeProperty);
	}

	[Test]
	public function shouldParseExplicitPositive():void
	{
		parser.parse(node, "explicitPositiveProperty", "12");
		Assert.assertEquals(12, node.explicitPositiveProperty);
	}

	[Test(expects="mockdown.errors.BlockParseError")]
	public function shouldNotAllowNegativeNumbers():void
	{
		parser.parse(node, "explicitPositiveProperty", "-12");
	}


	//---------------------------------
	//	Percent field
	//---------------------------------

	[Test]
	public function shouldAssignPercentageToAlternateField():void
	{
		parser.parse(node, "fromPercentageProperty", "20%");
		Assert.assertTrue(isNaN(node.fromPercentageProperty));
		Assert.assertEquals(20, node.toPercentageProperty);
	}
}
}