package mockdown.display
{
import mockdown.components.VisualNode;
import mockdown.utils.NodeTestUtil;

import org.flexunit.Assert;

public class RendererTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var renderer:Renderer;
	
	[Before]
	public function setup():void
	{
		renderer = new Renderer();
	}
	

	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	[Test(expects="ArgumentError")]
	public function shouldErrorIfNoRenderObjectClassSpecified():void
	{
		renderer.render(new VisualNode());
	}
	
	[Test]
	public function shouldReturnNullIfNoNodeSpecified():void
	{
		renderer.renderObjectClass = NOPRenderObject;
		Assert.assertNull(renderer.render(null));
	}
}
}

import mockdown.display.*;
import mockdown.geom.Point;
import mockdown.geom.Rectangle;

class NOPRenderObject implements IRenderObject
{
	public function get children():Array {return []}

	public function drawLine(p1:Point, p2:Point, stroke:Stroke):void {}
	public function drawRect(rect:Rectangle, stroke:Stroke, fill:Fill):void {}
	public function clear():void {}

	public function addChild(child:IRenderObject):void {}
	public function removeChild(child:IRenderObject):void {}
	public function removeAllChildren():void {}
}