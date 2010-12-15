package mockdown.components
{
import asunit.framework.Assert;

public class ComponentTest
{
	//--------------------------------------------------------------------------
	//
	//	Setup
	//
	//--------------------------------------------------------------------------

	private var component:Component;
	private var parent:Component;
	private var child:Component;
	
	[Before]
	public function setup():void
	{
		component = new Component();

		parent = new Component();
		child  = new Component();
		parent.addChild(child);
	}
	

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	//-----------------------------
	//  Children
	//-----------------------------

	[Test]
	public function shouldAddChild():void
	{
		var child:Component = new Component();
		component.addChild(child);
		Assert.assertEquals(child, component.children[0]);
	}

	[Test]
	public function shouldNotAddChildTwice():void
	{
		var child:Component = new Component();
		component.addChild(child);
		component.addChild(child);
		Assert.assertEquals(1, component.children.length);
	}

	[Test]
	public function shouldSetParentWhenAddingChild():void
	{
		var child:Component = new Component();
		component.addChild(child);
		Assert.assertEquals(component, child.parent);
	}

	[Test]
	public function shouldRemoveChild():void
	{
		var child:Component = new Component();
		component.addChild(child);
		component.removeChild(child);
		Assert.assertEquals(0, component.children.length);
	}

	[Test]
	public function shouldUnsetParentWhenRemovingChild():void
	{
		var child:Component = new Component();
		component.addChild(child);
		component.removeChild(child);
		Assert.assertNull(child.parent);
	}


	//-----------------------------
	//  Reset
	//-----------------------------

	[Test]
	public function shouldResetPixelWidth():void
	{
		component.pixelWidth = 100;
		component.reset();
		Assert.assertEquals(0, component.pixelWidth);
	}

	[Test]
	public function shouldResetPixelHeight():void
	{
		component.pixelHeight = 100;
		component.reset();
		Assert.assertEquals(0, component.pixelHeight);
	}

	[Test]
	public function shouldResetChildWidth():void
	{
		child.pixelWidth = 100;
		parent.reset();
		Assert.assertEquals(0, child.pixelWidth);
	}

	[Test]
	public function shouldResetChildHeight():void
	{
		child.pixelHeight = 100;
		parent.reset();
		Assert.assertEquals(0, child.pixelHeight);
	}



	//-----------------------------
	//  Measurement (Explicit)
	//-----------------------------

	[Test]
	public function shouldMeasureExplicitWidth():void
	{
		component.width = 100;
		component.measure();
		Assert.assertEquals(100, component.pixelWidth);
	}

	[Test]
	public function shouldMeasureExplicitHeight():void
	{
		component.height = 100;
		component.measure();
		Assert.assertEquals(100, component.pixelHeight);
	}


	//-----------------------------
	//  Measurement (Min/Max)
	//-----------------------------

	[Test]
	public function shouldRestrictWidthByMinWidth():void
	{
		component.width    = 50;
		component.minWidth = 100;
		component.measure();
		Assert.assertEquals(100, component.pixelWidth);
	}

	[Test]
	public function shouldRestrictHeihtByMinHeight():void
	{
		component.height    = 50;
		component.minHeight = 100;
		component.measure();
		Assert.assertEquals(100, component.pixelHeight);
	}

	[Test]
	public function shouldRestrictWidthByMaxWidth():void
	{
		component.width    = 150;
		component.maxWidth = 100;
		component.measure();
		Assert.assertEquals(100, component.pixelWidth);
	}

	[Test]
	public function shouldRestrictWidthByMaxHeight():void
	{
		component.height    = 150;
		component.maxHeight = 100;
		component.measure();
		Assert.assertEquals(100, component.pixelHeight);
	}


	//-----------------------------
	//  Measurement (Children)
	//-----------------------------

	[Test]
	public function shouldMeasureChildren():void
	{
		child.width  = 100;
		child.height = 200;
		parent.measure();
		Assert.assertEquals(100, child.pixelWidth);
		Assert.assertEquals(200, child.pixelHeight);
	}


	//-----------------------------
	//  Measurement (Implicit)
	//-----------------------------

	[Test]
	public function shouldMeasureImplicitWidth():void
	{
		var c0:Component, c1:Component;
		component.addChild(c0 = new Component());
		component.addChild(c1 = new Component());
		
		c0.width = 100;
		c1.width = 200;
		
		component.paddingLeft  = 1;
		component.paddingRight = 2;
		component.measure();

		Assert.assertEquals(203, component.pixelWidth);
	}

	[Test]
	public function shouldMeasureImplicitHeight():void
	{
		var c0:Component, c1:Component;
		component.addChild(c0 = new Component());
		component.addChild(c1 = new Component());
		
		c0.height = 100;
		c1.height = 200;
		
		component.paddingTop  = 1;
		component.paddingBottom = 2;
		component.measure();

		Assert.assertEquals(203, component.pixelHeight);
	}
}
}