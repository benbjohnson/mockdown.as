package mockdown.components.definitions
{
import mockdown.components.ActionScriptComponent;
import mockdown.components.Node;
import mockdown.utils.NodeTestUtil;

import asunit.framework.Assert;

public class RowTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var root:Node;
	private var nodes:Object;
	private var components:Object;
	
	[Before]
	public function setup():void
	{
		components = {
			node: new ActionScriptComponent("node", BaseComponent),
			row:  new ActionScriptComponent("row", Row)
		};
		components.row.parent = components.node;
		
		nodes = {};
	}
	
	[After]
	public function tearDown():void
	{
	}
	
	//---------------------------------
	//	Node Test Helpers
	//---------------------------------
	
	private function n(id:String, component:String, properties:Object, ...children):*
	{
		return NodeTestUtil.create(nodes, id, components[component], properties, children);
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
	//	Child aggregate width
	//---------------------------------
	
	[Test]
	public function shouldCalculateTotalPercentWidth():void
	{
		root = n(null, "row", {},
			n(null, "node", {width:"10%"}),
			n(null, "node", {width:"80"}),
			n(null, "node", {width:"30%"})
		);
		Assert.assertEquals(40, root.getTotalChildPercentWidth());
	}
	
	[Test]
	public function shouldCalculateTotalExplicitWidth():void
	{
		root = n(null, "row", {},
			n(null, "node", {width:"10"}),
			n(null, "node", {width:"80"}),
			n(null, "node", {width:"30%"})
		);
		Assert.assertEquals(90, root.getTotalChildExplicitWidth());
	}



	//---------------------------------
	//	Measurement
	//---------------------------------
	
	[Test]
	public function shouldMeasureImplicit():void
	{
		root = n("root", "row", {paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"40"}),
			n("b", "node", {width:"20", height:"50"}),
			n("c", "node", {width:"30", height:"60"})
		);
		root.measure();

		assertSize("root", 75, 63);
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
		root = n("root", "row", {width:"200", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"20%", height:"100%"}),
			n("b", "node", {width:"30%", height:"20%"}),
			n("c", "node", {width:"50", height:"20"}),
			n("d", "node", {width:"80", height:"60"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 200);
		assertDimension("a", 3, 1, 20, 200);
		assertDimension("b", 27, 1, 31, 40);
		assertDimension("c", 62, 1, 50, 20);
		assertDimension("d", 116, 1, 80, 60);
	}

	//---------------------------------
	//	Horizontal Alignment
	//---------------------------------
	
	[Test]
	public function shouldAlignLeft():void
	{
		root = n("root", "row", {align:"left", width:"200", height:"100", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 100);
		assertDimension("a", 3, 1, 10, 20);
		assertDimension("b", 17, 1, 30, 40);
	}

	[Test]
	public function shouldAlignCenter():void
	{
		root = n("root", "row", {align:"center", width:"200", height:"100", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 100);
		assertDimension("a", 77, 1, 10, 20);
		assertDimension("b", 91, 1, 30, 40);
	}

	[Test]
	public function shouldAlignRight():void
	{
		root = n("root", "row", {align:"right", width:"200", height:"100", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 100);
		assertDimension("a", 152, 1, 10, 20);
		assertDimension("b", 166, 1, 30, 40);
	}

	//---------------------------------
	//	Vertical Alignment
	//---------------------------------
	
	[Test]
	public function shouldVAlignTop():void
	{
		root = n("root", "row", {valign:"top", width:"100", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 100, 200);
		assertDimension("a", 3, 1, 10, 20);
		assertDimension("b", 17, 1, 30, 40);
	}

	[Test]
	public function shouldVAlignMiddle():void
	{
		root = n("root", "row", {valign:"middle", width:"100", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 100, 200);
		assertDimension("a", 3, 89, 10, 20);
		assertDimension("b", 17, 79, 30, 40);
	}

	[Test]
	public function shouldVAlignBottom():void
	{
		root = n("root", "row", {valign:"bottom", width:"100", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 100, 200);
		assertDimension("a", 3, 178, 10, 20);
		assertDimension("b", 17, 158, 30, 40);
	}
}
}