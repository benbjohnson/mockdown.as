package mockdown.components
{
import org.flexunit.Assert;

public class RowTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var row:Row;
	private var a:VisualNode;
	private var b:VisualNode;
	private var c:VisualNode;
	
	[Before]
	public function setup():void
	{
		row = new Row();
		
		a = new VisualNode();
		b = new VisualNode();
		c = new VisualNode();

		row.addChild(a);
		row.addChild(b);
		row.addChild(c);
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldCalculateTotalPercentWidth():void
	{
		a.width = "10%";
		b.width = "80";
		c.width = "30%";
		Assert.assertEquals(40, row.totalChildPercentWidth);
	}

	[Test]
	public function shouldCalculateTotalFixedWidth():void
	{
		a.width = "10";
		b.width = "80";
		c.width = "30%";
		Assert.assertEquals(90, row.totalChildFixedWidth);
	}
}
}