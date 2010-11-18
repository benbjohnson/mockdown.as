package mockdown.components
{
import org.flexunit.Assert;

public class ColumnTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var column:Column;
	private var a:VisualNode;
	private var b:VisualNode;
	private var c:VisualNode;
	
	[Before]
	public function setup():void
	{
		column = new Column();
		
		a = new VisualNode();
		b = new VisualNode();
		c = new VisualNode();

		column.addChild(a);
		column.addChild(b);
		column.addChild(c);
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldCalculateTotalPercentHeight():void
	{
		a.height = "10%";
		b.height = "80";
		c.height = "30%";
		Assert.assertEquals(40, column.totalChildPercentHeight);
	}
	
	[Test]
	public function shouldCalculateTotalFixedHeight():void
	{
		a.height = "10";
		b.height = "80";
		c.height = "30%";
		Assert.assertEquals(90, column.totalChildFixedHeight);
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldMeasurePercentChildrenOnly():void
	{
		column.height = "1000";
		a.height = "30%";
		b.height = "20%";
		c.height = "50%";
		column.measure();
		Assert.assertEquals(300, a.pixelHeight);
		Assert.assertEquals(200, b.pixelHeight);
		Assert.assertEquals(500, c.pixelHeight);
	}
	
	[Test]
	public function shouldMeasureUnevenPercentChildrenOnly():void
	{
		column.height = "1000";
		a.height = "37%";
		b.height = "15%";
		c.height = "5%";
		column.measure();
		Assert.assertEquals(649, a.pixelHeight);
		Assert.assertEquals(263, b.pixelHeight);
		Assert.assertEquals(88, c.pixelHeight);
	}

	[Test]
	public function shouldMeasureMixedChildren():void
	{
		column.height = "1000";
		a.height = "30%";
		b.height = "100";
		c.height = "50%";
		column.measure();
		Assert.assertEquals(338, a.pixelHeight);
		Assert.assertEquals(100, b.pixelHeight);
		Assert.assertEquals(562, c.pixelHeight);
	}

	[Test]
	public function shouldResizeWhenChildrenAreTooLarge():void
	{
		column.height = "100";
		a.height = "50";
		b.height = "100";
		c.height = "20%";
		column.measure();
		Assert.assertEquals(33, a.pixelHeight);
		Assert.assertEquals(67, b.pixelHeight);
		Assert.assertEquals(0, c.pixelHeight);
	}

	[Test]
	public function shouldMeasurePercentChildrenWithPadding():void
	{
		column.height = "1000";
		column.paddingTop = "20";
		column.paddingBottom = "60";
		a.height = "30%";
		b.height = "20%";
		c.height = "50%";
		column.measure();
		Assert.assertEquals(276, a.pixelHeight);
		Assert.assertEquals(184, b.pixelHeight);
		Assert.assertEquals(460, c.pixelHeight);
	}
}
}