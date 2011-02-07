package mockdown.components
{
import asunit.framework.Assert;
import org.hamcrest.assertThat;
import org.hamcrest.collection.*;

public class StyleComponentTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var component:StyleComponent;
	
	[Before]
	public function setup():void
	{
		component = new StyleComponent();
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

	[Test]
	public function shouldCascadeBorderTop():void
	{
		component.border = "10px #FF0000 20%";
		Assert.assertEquals("10px #FF0000 20%", component.borderTop);
		Assert.assertEquals("10px #FF0000 20%", component.borderBottom);
		Assert.assertEquals("10px #FF0000 20%", component.borderLeft);
		Assert.assertEquals("10px #FF0000 20%", component.borderRight);
	}

	[Test]
	public function shouldCascadeBorderThickness():void
	{
		component.borderThickness = 10;
		Assert.assertEquals(10, component.borderTopThickness);
		Assert.assertEquals(10, component.borderBottomThickness);
		Assert.assertEquals(10, component.borderLeftThickness);
		Assert.assertEquals(10, component.borderRightThickness);
	}

	[Test]
	public function shouldCascadeBorderColor():void
	{
		component.borderColor = 0xFF0000;
		Assert.assertEquals(0xFF0000, component.borderTopColor);
		Assert.assertEquals(0xFF0000, component.borderBottomColor);
		Assert.assertEquals(0xFF0000, component.borderLeftColor);
		Assert.assertEquals(0xFF0000, component.borderRightColor);
	}

	[Test]
	public function shouldCascadeBorderAlpha():void
	{
		component.borderAlpha = 20;
		Assert.assertEquals(20, component.borderTopAlpha);
		Assert.assertEquals(20, component.borderBottomAlpha);
		Assert.assertEquals(20, component.borderLeftAlpha);
		Assert.assertEquals(20, component.borderRightAlpha);
	}


	//---------------------------------
	//	Border Top
	//---------------------------------
	
	[Test]
	public function shouldSetBorderTopThickness():void
	{
		component.borderTop = "10px #FF0000";
		Assert.assertEquals(10, component.borderTopThickness);
	}

	[Test]
	public function shouldSetBorderTopColor():void
	{
		component.borderTop = "10px #FF0000";
		Assert.assertEquals(0xFF0000, component.borderTopColor);
	}

	[Test]
	public function shouldSetBorderTopAlpha():void
	{
		component.borderTop = "10px #FF0000 20%";
		Assert.assertEquals(20, component.borderTopAlpha);
	}


	//---------------------------------
	//	Border Bottom
	//---------------------------------
	
	[Test]
	public function shouldSetBorderBottomThickness():void
	{
		component.borderBottom = "10px #FF0000";
		Assert.assertEquals(10, component.borderBottomThickness);
	}

	[Test]
	public function shouldSetBorderBottomColor():void
	{
		component.borderBottom = "10px #FF0000";
		Assert.assertEquals(0xFF0000, component.borderBottomColor);
	}

	[Test]
	public function shouldSetBorderBottomAlpha():void
	{
		component.borderBottom = "10px #FF0000 20%";
		Assert.assertEquals(20, component.borderBottomAlpha);
	}


	//---------------------------------
	//	Border Left
	//---------------------------------
	
	[Test]
	public function shouldSetBorderLeftThickness():void
	{
		component.borderLeft = "10px #FF0000";
		Assert.assertEquals(10, component.borderLeftThickness);
	}

	[Test]
	public function shouldSetBorderLeftColor():void
	{
		component.borderLeft = "10px #FF0000";
		Assert.assertEquals(0xFF0000, component.borderLeftColor);
	}

	[Test]
	public function shouldSetBorderLeftAlpha():void
	{
		component.borderLeft = "10px #FF0000 20%";
		Assert.assertEquals(20, component.borderLeftAlpha);
	}


	//---------------------------------
	//	Border Right
	//---------------------------------
	
	[Test]
	public function shouldSetBorderRightThickness():void
	{
		component.borderRight = "10px #FF0000";
		Assert.assertEquals(10, component.borderRightThickness);
	}

	[Test]
	public function shouldSetBorderRightColor():void
	{
		component.borderRight = "10px #FF0000";
		Assert.assertEquals(0xFF0000, component.borderRightColor);
	}

	[Test]
	public function shouldSetBorderRightAlpha():void
	{
		component.borderRight = "10px #FF0000 20%";
		Assert.assertEquals(20, component.borderRightAlpha);
	}


	//---------------------------------
	//	Border Radius
	//---------------------------------
	
	[Test]
	public function shouldParseBlankBorderRadius():void
	{
		component.borderRadius = "";
		Assert.assertEquals(0, component.borderTopLeftRadius);
		Assert.assertEquals(0, component.borderTopRightRadius);
		Assert.assertEquals(0, component.borderBottomRightRadius);
		Assert.assertEquals(0, component.borderBottomLeftRadius);
	}

	[Test]
	public function shouldParse1ArgBorderRadius():void
	{
		component.borderRadius = "1";
		Assert.assertEquals(1, component.borderTopLeftRadius);
		Assert.assertEquals(1, component.borderTopRightRadius);
		Assert.assertEquals(1, component.borderBottomRightRadius);
		Assert.assertEquals(1, component.borderBottomLeftRadius);
	}
	
	[Test]
	public function shouldParse2ArgBorderRadius():void
	{
		component.borderRadius = "1 2";
		Assert.assertEquals(1, component.borderTopLeftRadius);
		Assert.assertEquals(2, component.borderTopRightRadius);
		Assert.assertEquals(1, component.borderBottomRightRadius);
		Assert.assertEquals(2, component.borderBottomLeftRadius);
	}
	
	[Test]
	public function shouldParse3ArgBorderRadius():void
	{
		component.borderRadius = "1 2 3";
		Assert.assertEquals(1, component.borderTopLeftRadius);
		Assert.assertEquals(2, component.borderTopRightRadius);
		Assert.assertEquals(3, component.borderBottomRightRadius);
		Assert.assertEquals(2, component.borderBottomLeftRadius);
	}
	
	[Test]
	public function shouldParse4ArgBorderRadius():void
	{
		component.borderRadius = "1 2 3 4";
		Assert.assertEquals(1, component.borderTopLeftRadius);
		Assert.assertEquals(2, component.borderTopRightRadius);
		Assert.assertEquals(3, component.borderBottomRightRadius);
		Assert.assertEquals(4, component.borderBottomLeftRadius);
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

	[Test(expects="ArgumentError", message="Too many alpha values specified")]
	public function shouldThrowErrorIfColorAndAlphasCountsDoNotMatch():void
	{
		component.background = "#FF0000,#0000FF 20%,50%,100%";
	}

	[Test]
	public function shouldSetBackgroundGradientType():void
	{
		component.background = "#FF0000,#0000FF";
		assertThat(component.backgroundColors, array([0xFF0000, 0x0000FF]));
	}
}
}