package mockdown.components.definitions
{
import mockdown.components.ActionScriptComponent;
import mockdown.components.Component;
import mockdown.components.Node;
import mockdown.utils.NodeTestUtil;

import asunit.framework.Assert;

public class ColumnTest
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
		var base:Component = new ActionScriptComponent("node", BaseComponent);
		components = {
			node: base,
			col:  new ActionScriptComponent("col", Column, base)
		};
		
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
	//  Properties
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldHaveBaseProperties():void
	{
		Assert.assertNotNull(components.col.getProperty("width"));
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
		root = n("root", "col", {},
			n("a", "node", {height:"10%"}),
			n("b", "node", {height:"80"}),
			n("c", "node", {height:"30%"})
		);
		Assert.assertEquals(40, root.getTotalChildPercentHeight());
	}
	
	[Test]
	public function shouldCalculateTotalExplicitHeight():void
	{
		root = n(null, "col", {},
			n(null, "node", {height:"10"}),
			n(null, "node", {height:"80"}),
			n(null, "node", {height:"30%"})
		);
		Assert.assertEquals(90, root.getTotalChildExplicitHeight());
	}



	//---------------------------------
	//	Measurement
	//---------------------------------
	
	[Test]
	public function shouldMeasureImplicit():void
	{
		root = n("root", "col", {paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"40"}),
			n("b", "node", {width:"20", height:"50"}),
			n("c", "node", {width:"30", height:"60"})
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
		trace("-->shouldLayoutPercentChildren");
		root = n("root", "col", {width:"200", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"100%", height:"20%"}),
			n("b", "node", {width:"20%", height:"30%"}),
			n("c", "node", {width:"50", height:"20"}),
			n("d", "node", {width:"80", height:"60"})
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
		root = n("root", "col", {align:"left", width:"200", height:"100", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 100);
		assertDimension("a", 3, 1, 10, 20);
		assertDimension("b", 3, 25, 30, 40);
	}

	[Test]
	public function shouldAlignCenter():void
	{
		root = n("root", "col", {align:"center", width:"200", height:"100", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 100);
		assertDimension("a", 94, 1, 10, 20);
		assertDimension("b", 84, 25, 30, 40);
	}

	[Test]
	public function shouldAlignRight():void
	{
		root = n("root", "col", {align:"right", width:"200", height:"100", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 200, 100);
		assertDimension("a", 186, 1, 10, 20);
		assertDimension("b", 166, 25, 30, 40);
	}

	//---------------------------------
	//	Vertical Alignment
	//---------------------------------
	
	[Test]
	public function shouldVAlignTop():void
	{
		root = n("root", "col", {valign:"top", width:"100", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 100, 200);
		assertDimension("a", 3, 1, 10, 20);
		assertDimension("b", 3, 25, 30, 40);
	}

	[Test]
	public function shouldVAlignMiddle():void
	{
		root = n("root", "col", {valign:"middle", width:"100", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 100, 200);
		assertDimension("a", 3, 67, 10, 20);
		assertDimension("b", 3, 91, 30, 40);
	}

	[Test]
	public function shouldVAlignBottom():void
	{
		root = n("root", "col", {valign:"bottom", width:"100", height:"200", paddingTop:"1", paddingBottom:"2", paddingLeft:"3", paddingRight:"4", gap:4},
			n("a", "node", {width:"10", height:"20"}),
			n("b", "node", {width:"30", height:"40"})
		);
		root.measure();
		root.layout();

		assertDimension("root", 0, 0, 100, 200);
		assertDimension("a", 3, 134, 10, 20);
		assertDimension("b", 3, 158, 30, 40);
	}
}
}