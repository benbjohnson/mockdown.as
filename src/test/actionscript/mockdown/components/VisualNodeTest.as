package mockdown.components
{
import org.flexunit.Assert;

public class VisualNodeTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var a:VisualNode;
	private var aa:VisualNode;
	private var ab:VisualNode;
	private var aaa:VisualNode;
	private var aab:VisualNode;
	private var aac:VisualNode;
	
	[Before]
	public function setup():void
	{
		a = new VisualNode();
		aa = new VisualNode();
		ab = new VisualNode();
		aaa = new VisualNode();
		aab = new VisualNode();
		aac = new VisualNode();
		
		a.addChild(aa);
		a.addChild(ab);
		aa.addChild(aaa);
		aa.addChild(aab);
		aa.addChild(aac);
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldNotAllowNegativePixelWidth():void
	{
		a.pixelWidth = -10;
		Assert.assertEquals(0, a.pixelWidth);
	}

	[Test]
	public function shouldNotAllowFractionalPixelWidth():void
	{
		a.pixelWidth = 2.5;
		Assert.assertEquals(3, a.pixelWidth);
	}
	
	[Test]
	public function shouldNotAllowNegativePixelHeight():void
	{
		a.pixelHeight = -10;
		Assert.assertEquals(0, a.pixelHeight);
	}

	[Test]
	public function shouldNotAllowFractionalPixelHeight():void
	{
		a.pixelHeight = 2.5;
		Assert.assertEquals(3, a.pixelHeight);
	}
	

	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Measure
	//-----------------------------

	[Test]
	public function shouldSetExplicitWidth():void
	{
		a.width = "10";
		a.measure();
		Assert.assertEquals(10, a.pixelWidth);
	}

	[Test]
	public function shouldSetExplicitHeight():void
	{
		a.height = "20";
		a.measure();
		Assert.assertEquals(20, a.pixelHeight);
	}
}
}