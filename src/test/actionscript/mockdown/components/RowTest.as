package mockdown.components
{
import asunit.framework.Assert;

public class RowTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var root:Row;
	private var a:Component;
	private var b:Component;
	private var c:Component;
	
	[Before]
	public function setup():void
	{
		root = new Row();
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
	//	Child aggregate width
	//---------------------------------
	
	[Test]
	public function shouldCalculateTotalPercentWidth():void
	{
		a.percentWidth = 10;
		b.width = 80;
		c.percentWidth = 30;
		Assert.assertEquals(40, root.getTotalChildPercentWidth());
	}
	
	[Test]
	public function shouldCalculateTotalExplicitWidth():void
	{
		a.width = 10;
		b.width = 80;
		c.percentWidth = 30;
		Assert.assertEquals(90, root.getTotalChildExplicitWidth());
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
		Assert.assertEquals(75, root.pixelWidth);
	}

	[Test]
	public function shouldMeasureImplicitHeight():void
	{
		a.height = 10;
		b.height = 20;
		c.height = 30;

		root.measure();
		Assert.assertEquals(33, root.pixelHeight);
	}
	
	
	//---------------------------------
	//	Layout (Percentage)
	//---------------------------------
	
	[Test]
	public function shouldLayoutPercentHeight():void
	{
		root.height = 200;
		a.percentHeight = 10;
		b.height = 25;
		c.percentHeight = 30;

		root.measure();
		root.layout();

		Assert.assertEquals("a", 20, a.pixelHeight);
		Assert.assertEquals("b", 25, b.pixelHeight);
		Assert.assertEquals("c", 60, c.pixelHeight);
	}

	[Test]
	public function shouldLayoutPercentWidth():void
	{
		root.width = 200;

		a.percentWidth = 10;
		b.width = 20;
		c.percentWidth = 30;

		root.measure();
		root.layout();

		Assert.assertEquals("a", 41, a.pixelWidth);
		Assert.assertEquals("b", 20, b.pixelWidth);
		Assert.assertEquals("c", 124, c.pixelWidth);
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
		b.width = 20;
		c.width = 30;

		root.measure();
		root.layout();

		Assert.assertEquals(3, a.x);
		Assert.assertEquals(17, b.x);
		Assert.assertEquals(41, c.x);
	}
	
	[Test]
	public function shouldLayoutAlignCenter():void
	{
		root.align = "center";
		root.width = 200;
		a.width = 10;
		b.width = 20;
		c.width = 30;

		root.measure();
		root.layout();

		Assert.assertEquals(65, a.x);
		Assert.assertEquals(79, b.x);
		Assert.assertEquals(103, c.x);
	}
	
	[Test]
	public function shouldLayoutAlignRight():void
	{
		root.align = "right";
		root.width = 200;
		a.width = 10;
		b.width = 20;
		c.width = 30;

		root.measure();
		root.layout();

		Assert.assertEquals(128, a.x);
		Assert.assertEquals(142, b.x);
		Assert.assertEquals(166, c.x);
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

		root.measure();
		root.layout();

		Assert.assertEquals(1, a.y);
	}

	[Test]
	public function shouldLayoutVAlignMiddle():void
	{
		root.valign = "middle";
		root.height = 200;
		a.height = 10;

		root.measure();
		root.layout();

		Assert.assertEquals(94, a.y);
	}

	[Test]
	public function shouldLayoutVAlignBottom():void
	{
		root.valign = "bottom";
		root.height = 200;
		a.height = 10;

		root.measure();
		root.layout();

		Assert.assertEquals(188, a.y);
	}
}
}