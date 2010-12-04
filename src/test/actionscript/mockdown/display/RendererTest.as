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

	public function move(x:int, y:int):void {}
	public function resize(width:uint, height:uint):void {}
	
	public function drawLine(x1:int, y1:int, x2:int, y2:int, stroke:Stroke):void {}
	public function drawRect(rect:Rectangle, stroke:Stroke, fill:Fill=null):void {}
	public function clear():void {}

	public function addRenderChild(child:IRenderObject):void {}
	public function removeRenderChild(child:IRenderObject):void {}
	public function removeAllRenderChildren():void {}
}