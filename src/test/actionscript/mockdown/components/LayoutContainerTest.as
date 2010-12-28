package mockdown.components
{
import asunit.framework.Assert;

public class LayoutContainerTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var component:LayoutContainer;
	
	[Before]
	public function setup():void
	{
		component = new LayoutContainer();
		component.pixelWidth  = 100;
		component.pixelHeight = 200;
	}


	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Border
	//---------------------------------
	
	[Test]
	public function shouldSetBorderThickness():void
	{
		component.border = "10px #FF0000";
		Assert.assertEquals(10, component.borderThickness);
	}

	[Test]
	public function shouldSetBorderColor():void
	{
		component.border = "10px #FF0000";
		Assert.assertEquals(0xFF0000, component.borderColor);
	}

	[Test]
	public function shouldSetBorderAlpha():void
	{
		component.border = "10px #FF0000 20%";
		Assert.assertEquals(20, component.borderAlpha);
	}


	//---------------------------------
	//	Background
	//---------------------------------
	
	[Test]
	public function shouldSetBackgroundColor():void
	{
		component.background = "#FF0000";
		Assert.assertEquals(0xFF0000, component.backgroundColor);
	}
}
}