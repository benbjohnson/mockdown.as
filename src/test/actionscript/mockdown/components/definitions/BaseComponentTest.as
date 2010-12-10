package mockdown.components.definitions
{
import mockdown.components.ActionScriptComponent;
import mockdown.components.Node;

import asunit.framework.Assert;

public class BaseComponentTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var component:ActionScriptComponent;
	private var node:Node;
	
	[Before]
	public function setup():void
	{
		component = new ActionScriptComponent("component", BaseComponent);
		node = new Node(component);
	}
	
	[After]
	public function tearDown():void
	{
	}
	
	//---------------------------------
	//	Node Test Helpers
	//---------------------------------
	
	/*
	private function n(id:String, clazz:Class, properties:Object, ...children):*
	{
		return NodeTestUtil.create(nodes, id, clazz, properties, children);
	}

	private function assertSize(id:String, w:uint, h:uint):void
	{
		NodeTestUtil.assertSize(nodes, id, w, h);
	}

	private function assertDimension(id:String, x:int, y:int, w:uint, h:uint):void
	{
		NodeTestUtil.assertDimension(nodes, id, x, y, w, h);
	}
	*/
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------

	//---------------------------------
	//	No Dimension
	//---------------------------------

	[Test]
	public function shouldMeasureZeroWidthWhenNotSpecified():void
	{
		node.measure();
		Assert.assertEquals(0, node.pixelWidth);
	}

	[Test]
	public function shouldMeasureZeroHeightWhenNotSpecified():void
	{
		node.measure();
		Assert.assertEquals(0, node.pixelHeight);
	}

	//---------------------------------
	//	Dimension
	//---------------------------------

	[Test]
	public function shouldMeasureWidth():void
	{
		node.width  = "100";
		node.measure();
		Assert.assertEquals(100, node.pixelWidth);
	}

	[Test]
	public function shouldMeasureHeight():void
	{
		node.height  = "100";
		node.measure();
		Assert.assertEquals(100, node.pixelHeight);
	}


	//---------------------------------
	//	Min Dimension
	//---------------------------------

	[Test]
	public function shouldRestrictToMinWidth():void
	{
		node.minWidth  = "20";
		node.width     = "10";
		node.measure();
		Assert.assertEquals(20, node.pixelWidth);
	}

	[Test]
	public function shouldRestrictToMinHeight():void
	{
		node.minHeight  = "20";
		node.height     = "10";
		node.measure();
		Assert.assertEquals(20, node.pixelHeight);
	}


	//---------------------------------
	//	Max Dimension
	//---------------------------------

	[Test]
	public function shouldRestrictToMaxWidth():void
	{
		node.maxWidth  = "50";
		node.width     = "100";
		node.measure();
		Assert.assertEquals(50, node.pixelWidth);
	}

	[Test]
	public function shouldRestrictToMaxHeight():void
	{
		node.maxHeight  = "50";
		node.height     = "100";
		node.measure();
		Assert.assertEquals(50, node.pixelHeight);
	}


	//---------------------------------
	//	Children
	//---------------------------------

	[Test]
	public function shouldMeasureChildren():void
	{
		trace("--> sMC");
		var child:Node = new Node(component);
		child.width = "100";
		node.addChild(child);
		node.measure();
		Assert.assertEquals(100, child.pixelWidth);
	}
	

	//---------------------------------
	//	Implicit measurement
	//---------------------------------

	[Test]
	public function shouldImplicitlyMeasureWidth():void
	{
		var c0:Node = new Node(component);
		var c1:Node = new Node(component);
		c0.width = "20";
		c1.width = "80";
		node.addChild(c0);
		node.addChild(c1);
		
		node.paddingLeft = "1";
		node.paddingRight = "2";
		node.measure();
		
		Assert.assertEquals(83, node.pixelWidth);
	}

	[Test]
	public function shouldImplicitlyMeasureHeight():void
	{
		var c0:Node = new Node(component);
		var c1:Node = new Node(component);
		c0.height = "20";
		c1.height = "80";
		node.addChild(c0);
		node.addChild(c1);
		
		node.paddingTop = "1";
		node.paddingBottom = "2";
		node.measure();
		
		Assert.assertEquals(83, node.pixelHeight);
	}
}
}