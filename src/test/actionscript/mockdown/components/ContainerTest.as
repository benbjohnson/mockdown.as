package mockdown.components
{
import org.flexunit.Assert;

public class ContainerTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var container:Container;
	
	[Before]
	public function setup():void
	{
		container = new Container();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldCalculateFixedPaddingTop():void
	{
		container.paddingTop = "10";
		Assert.assertEquals(10, container.pixelPaddingTop);
	}

	[Test]
	public function shouldCalculateFixedPaddingBottom():void
	{
		container.paddingBottom = "30";
		Assert.assertEquals(30, container.pixelPaddingBottom);
	}

	[Test]
	public function shouldCalculateFixedPaddingLeft():void
	{
		container.paddingLeft = "20";
		Assert.assertEquals(20, container.pixelPaddingLeft);
	}

	[Test]
	public function shouldCalculateFixedPaddingRight():void
	{
		container.paddingRight = "40";
		Assert.assertEquals(40, container.pixelPaddingRight);
	}
}
}