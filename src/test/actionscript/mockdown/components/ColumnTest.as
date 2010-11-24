package mockdown.components
{
import mockdown.utils.NodeTestUtil;

import org.flexunit.Assert;

public class ColumnTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var root:Column;
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

	private function assertDimension(id:String, x:int, y:int, w:uint, h:uint):void
	{
		NodeTestUtil.assertDimension(nodes, id, x, y, w, h);
	}

	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Child aggregate height
	//---------------------------------
	
	[Test]
	public function shouldCalculateTotalPercentHeight():void
	{
		root = n(null, Column, {},
			n(null, VisualNode, {height:"10%"}),
			n(null, VisualNode, {height:"80"}),
			n(null, VisualNode, {height:"30%"})
		);
		Assert.assertEquals(40, root.getTotalChildPercentHeight());
	}
	
	[Test]
	public function shouldCalculateTotalExplicitHeight():void
	{
		root = n(null, Column, {},
			n(null, VisualNode, {height:"10"}),
			n(null, VisualNode, {height:"80"}),
			n(null, VisualNode, {height:"30%"})
		);
		Assert.assertEquals(90, root.getTotalChildExplicitHeight());
	}



	//---------------------------------
	//	Measurement
	//---------------------------------
	
	[Test]
	public function shouldMeasureImplicit():void
	{
		root = n("root", Column, {paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", VisualNode, {width:"10", height:"40"}),
			n("b", VisualNode, {width:"20", height:"50"}),
			n("c", VisualNode, {width:"30", height:"60"})
		);
		root.measure();

		assertSize("root", 37, 161);
		assertSize("a", 10, 40);
		assertSize("b", 20, 50);
		assertSize("c", 30, 60);
	}

	//---------------------------------
	//	Layout
	//---------------------------------
	
	[Test]
	public function shouldLayoutPercentChildren():void
	{
		root = n("root", Column, {width:"200", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", VisualNode, {width:"100%", height:"20%"}),
			n("b", VisualNode, {width:"20%", height:"30%"}),
			n("c", VisualNode, {width:"50", height:"20"}),
			n("d", VisualNode, {width:"80", height:"60"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 200);
		assertDimension("a", 3, 1, 200, 42);
		assertDimension("b", 3, 47, 40, 63);
		assertDimension("c", 3, 114, 50, 20);
		assertDimension("d", 3, 138, 80, 60);
	}

	//---------------------------------
	//	Horizontal Alignment
	//---------------------------------
	
	[Test]
	public function shouldAlignLeft():void
	{
		root = n("root", Column, {align:"left", width:"200", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", VisualNode, {width:"10", height:"20"}),
			n("b", VisualNode, {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 200);
		assertDimension("a", 3, 1, 10, 20);
		assertDimension("b", 3, 25, 30, 40);
	}

	[Test]
	public function shouldAlignCenter():void
	{
		root = n("root", Column, {align:"center", width:"200", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", VisualNode, {width:"10", height:"20"}),
			n("b", VisualNode, {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 200);
		assertDimension("a", 95, 1, 10, 20);
		assertDimension("b", 85, 25, 30, 40);
	}

	[Test]
	public function shouldAlignRight():void
	{
		root = n("root", Column, {align:"right", width:"200", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", VisualNode, {width:"10", height:"20"}),
			n("b", VisualNode, {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 200);
		assertDimension("a", 186, 1, 10, 20);
		assertDimension("b", 166, 25, 30, 40);
	}

	//---------------------------------
	//	Vertical Alignment
	//---------------------------------
	
	[Test]
	public function shouldVAlignTop():void
	{
		root = n("root", Column, {valign:"top", width:"200", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", VisualNode, {width:"10", height:"20"}),
			n("b", VisualNode, {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 200);
		assertDimension("a", 3, 1, 10, 20);
		assertDimension("b", 3, 25, 30, 40);
	}

	[Test]
	public function shouldVAlignMiddle():void
	{
		root = n("root", Column, {valign:"middle", width:"200", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", VisualNode, {width:"10", height:"20"}),
			n("b", VisualNode, {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 200);
		assertDimension("a", 3, 68, 10, 20);
		assertDimension("b", 3, 92, 30, 40);
	}
}
}