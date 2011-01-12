package mockdown.components
{
import asunit.framework.Assert;
import org.hamcrest.assertThat;
import org.hamcrest.collection.*;

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

	[Test]
	public function shouldSetBackgroundColors():void
	{
		component.background = "#FF0000,#0000FF";
		assertThat(component.backgroundColors, array([0xFF0000, 0x0000FF]));
	}

	[Test]
	public function shouldSetBackgroundAlpha():void
	{
		component.background = "#FF0000 20%";
		assertThat(component.backgroundAlph, 20);
	}

	[Test]
	public function shouldSetBackgroundAlphas():void
	{
		component.background = "#FF0000,#0000FF 20%,30%";
		assertThat(component.backgroundAlphas, array([20, 30]));
	}

	[Test]
	public function shouldDefaultBackgroundAlphasIfNoneSpecified():void
	{
		component.background = "#FF0000,#0000FF";
		assertThat(component.backgroundAlphas, array([100, 100]));
	}

	[Test(expects="flash.errors.IllegalOperationError", message="The number of colors and alphas must match")]
	public function shouldThrowErrorIfColorAndAlphasCountsDoNotMatch():void
	{
		component.background = "#FF0000,#0000FF 20%";
	}

	[Test]
	public function shouldSetBackgroundGradientType():void
	{
		component.background = "#FF0000,#0000FF";
		assertThat(component.backgroundColors, array([0xFF0000, 0x0000FF]));
	}
}
}