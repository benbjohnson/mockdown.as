package mockdown.components
{
import mockdown.utils.NodeTestUtil;

import org.flexunit.Assert;

public class VisualNodeTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var root:VisualNode;
	private var nodes:Object;
	
	[Before]
	public function setup():void
	{
		nodes = {};
	}
	
	[After]
	public function tearDown():void
	{
	}
	
	//---------------------------------
	//	Node Test Helpers
	//---------------------------------
	
	private function n(id:String, clazz:Class, properties:Object, ...children):*
	{
		return NodeTestUtil.create(nodes, id, clazz, properties, children);
	}

	private function assertSize(id:String, w:uint, h:uint):void
	{
		NodeTestUtil.assertSize(nodes, id, w, h);
	}
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Padding
	//-----------------------------

	[Test]
	public function shouldMeasurePaddingTop():void
	{
		root = n(null, VisualNode, {paddingTop:"10"});
		root.measure();
		Assert.assertEquals(10, root.pixelPaddingTop);
	}
	
	[Test]
	public function shouldMeasurePaddingBottom():void
	{
		root = n(null, VisualNode, {paddingBottom:"10"});
		root.measure();
		Assert.assertEquals(10, root.pixelPaddingBottom);
	}
	
	[Test]
	public function shouldMeasurePaddingLeft():void
	{
		root = n(null, VisualNode, {paddingLeft:"10"});
		root.measure();
		Assert.assertEquals(10, root.pixelPaddingLeft);
	}
	
	[Test]
	public function shouldMeasurePaddingRight():void
	{
		root = n(null, VisualNode, {paddingRight:"10"});
		root.measure();
		Assert.assertEquals(10, root.pixelPaddingRight);
	}


	//-----------------------------
	//  Measure (Explicit)
	//-----------------------------

	[Test]
	public function shouldSetExplicitWidth():void
	{
		root = n(null, VisualNode, {width:"10"});
		root.measure();
		Assert.assertEquals(10, root.pixelWidth);
	}

	[Test]
	public function shouldRestrictExplicitToMinWidth():void
	{
		root = n(null, VisualNode, {width:"10", minWidth:"20"});
		root.measure();
		Assert.assertEquals(20, root.pixelWidth);
		Assert.assertEquals(20, root.pixelMinWidth);
	}

	[Test]
	public function shouldRestrictExplicitToMaxWidth():void
	{
		root = n(null, VisualNode, {width:"30", maxWidth:"20"});
		root.measure();
		Assert.assertEquals(20, root.pixelWidth);
		Assert.assertEquals(20, root.pixelMaxWidth);
	}

	[Test]
	public function shouldSetExplicitHeight():void
	{
		root = n(null, VisualNode, {height:"20"});
		root.measure();
		Assert.assertEquals(20, root.pixelHeight);
	}

	[Test]
	public function shouldRestrictExplicitToMinHeight():void
	{
		root = n(null, VisualNode, {height:"10", minHeight:"20"});
		root.measure();
		Assert.assertEquals(20, root.pixelHeight);
		Assert.assertEquals(20, root.pixelMinHeight);
	}

	[Test]
	public function shouldRestrictExplicitToMaxHeight():void
	{
		root = n(null, VisualNode, {height:"30", maxHeight:"20"});
		root.measure();
		Assert.assertEquals(20, root.pixelHeight);
		Assert.assertEquals(20, root.pixelMaxHeight);
	}

	//-----------------------------
	//  Measure (Implicit)
	//-----------------------------

	[Test]
	public function shouldSetImplicitWidth():void
	{
		root = n(null, VisualNode, {paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4"},
					n("a", VisualNode, {width:20}),
					n("b", VisualNode, {width:30})
				);
		root.measure();
		Assert.assertEquals(37, root.pixelWidth);
	}

	[Test]
	public function shouldRestrictImplicitToMinWidth():void
	{
		root = n(null, VisualNode, {minWidth:"100", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4"},
					n("a", VisualNode, {width:20}),
					n("b", VisualNode, {width:30})
				);
		root.measure();
		Assert.assertEquals(100, root.pixelWidth);
	}

	[Test]
	public function shouldRestrictImplicitToMaxWidth():void
	{
		root = n(null, VisualNode, {maxWidth:"10", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4"},
					n("a", VisualNode, {width:20}),
					n("b", VisualNode, {width:30})
				);
		root.measure();
		Assert.assertEquals(10, root.pixelWidth);
	}

	[Test]
	public function shouldSetImplicitHeight():void
	{
		root = n(null, VisualNode, {paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4"},
					n("a", VisualNode, {height:20}),
					n("b", VisualNode, {height:30})
				);
		root.measure();
		Assert.assertEquals(33, root.pixelHeight);
	}

	[Test]
	public function shouldRestrictImplicitToMinHeight():void
	{
		root = n(null, VisualNode, {minHeight:"100", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4"},
					n("a", VisualNode, {height:20}),
					n("b", VisualNode, {height:30})
				);
		root.measure();
		Assert.assertEquals(100, root.pixelHeight);
	}

	[Test]
	public function shouldRestrictImplicitToMaxHeight():void
	{
		root = n(null, VisualNode, {maxHeight:"10", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4"},
					n("a", VisualNode, {height:20}),
					n("b", VisualNode, {height:30})
				);
		root.measure();
		Assert.assertEquals(10, root.pixelHeight);
	}
}
}