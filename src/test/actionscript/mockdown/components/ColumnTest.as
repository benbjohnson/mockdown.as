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
	public function shouldMeasureExplicitChildren():void
	{
		root = n("root", Column, {width:"300", height:"200"},
			n("a", VisualNode, {width:"10", height:"20"},
				n("aa", VisualNode, {width:"30", height:"40"}),
				n("ab", VisualNode, {width:"50", height:"60"})
			)
		);
		root.measure();

		assertSize("root", 300, 200);
		assertSize("a", 10, 20);
		assertSize("aa", 30, 40);
		assertSize("ab", 50, 60);
	}
}
}