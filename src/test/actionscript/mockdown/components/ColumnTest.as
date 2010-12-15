package mockdown.components
{
import asunit.framework.Assert;

public class ColumnTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var root:Column;
	private var a:Component;
	private var b:Component;
	private var c:Component;
	
	[Before]
	public function setup():void
	{
		root = new Column();
		root.paddingTop    = 1;
		root.paddingBottom = 2;
		root.paddingLeft   = 3;
		root.paddingRight  = 4;
		root.gap = 4;

		root.addChild(a = new Component());
		root.addChild(b = new Component());
		root.addChild(c = new Component());
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Child aggregate height
	//---------------------------------
	
	[Test]
	public function shouldCalculateTotalPercentHeight():void
	{
		a.percentHeight = 10;
		b.height = 80;
		c.percentHeight = 30;
		Assert.assertEquals(40, root.getTotalChildPercentHeight());
	}
	
	[Test]
	public function shouldCalculateTotalExplicitHeight():void
	{
		a.height = 10;
		b.height = 80;
		c.percentHeight = 30;
		Assert.assertEquals(90, root.getTotalChildExplicitHeight());
	}


	//---------------------------------
	//	Measurement (Implicit)
	//---------------------------------
	
	[Test]
	public function shouldMeasureImplicitWidth():void
	{
		a.width = 10;
		b.width = 20;
		c.width = 30;

		root.measure();
		Assert.assertEquals(37, root.pixelWidth);
	}

	[Test]
	public function shouldMeasureImplicitHeight():void
	{
		a.height = 10;
		b.height = 20;
		c.height = 30;

		root.measure();
		Assert.assertEquals(71, root.pixelHeight);
	}
	
	
	//---------------------------------
	//	Layout (Percentage)
	//---------------------------------
	
	[Test]
	public function shouldLayoutPercentWidth():void
	{
		root.width = 200;
		a.percentWidth = 10;
		b.width = 25;
		c.percentWidth = 30;

		root.measure();
		root.layout();

		Assert.assertEquals("a", 20, a.pixelWidth);
		Assert.assertEquals("b", 25, b.pixelWidth);
		Assert.assertEquals("c", 60, c.pixelWidth);
	}

	[Test]
	public function shouldLayoutPercentHeight():void
	{
		root.height = 200;

		a.percentHeight = 10;
		b.height = 20;
		c.percentHeight = 30;

		root.measure();
		root.layout();

		Assert.assertEquals("a", 42, a.pixelHeight);
		Assert.assertEquals("b", 20, b.pixelHeight);
		Assert.assertEquals("c", 127, c.pixelHeight);
	}


	//---------------------------------
	//	Layout (Horizontal Align)
	//---------------------------------
	
	[Test]
	public function shouldLayoutAlignLeft():void
	{
		root.align = "left";
		root.width = 200;
		a.width = 10;

		root.measure();
		root.layout();

		Assert.assertEquals(3, a.x);
	}

	[Test]
	public function shouldLayoutAlignCenter():void
	{
		root.align = "center";
		root.width = 200;
		a.width = 10;

		root.measure();
		root.layout();

		Assert.assertEquals(94, a.x);
	}

	[Test]
	public function shouldLayoutAlignRight():void
	{
		root.align = "right";
		root.width = 200;
		a.width = 10;

		root.measure();
		root.layout();

		Assert.assertEquals(186, a.x);
	}


	//---------------------------------
	//	Layout (Vertical Align)
	//---------------------------------
	
	[Test]
	public function shouldLayoutVAlignTop():void
	{
		root.valign = "top";
		root.height = 200;
		a.height = 10;
		b.height = 20;
		c.height = 30;

		root.measure();
		root.layout();

		Assert.assertEquals(1, a.y);
		Assert.assertEquals(15, b.y);
		Assert.assertEquals(39, c.y);
	}
	
	[Test]
	public function shouldLayoutVAlignMiddle():void
	{
		root.valign = "middle";
		root.height = 200;
		a.height = 10;
		b.height = 20;
		c.height = 30;

		root.measure();
		root.layout();

		Assert.assertEquals(65, a.y);
		Assert.assertEquals(79, b.y);
		Assert.assertEquals(103, c.y);
	}
	
	[Test]
	public function shouldLayoutVAlignBottom():void
	{
		root.valign = "bottom";
		root.height = 200;
		a.height = 10;
		b.height = 20;
		c.height = 30;

		root.measure();
		root.layout();

		Assert.assertEquals(130, a.y);
		Assert.assertEquals(144, b.y);
		Assert.assertEquals(168, c.y);
	}
}
}