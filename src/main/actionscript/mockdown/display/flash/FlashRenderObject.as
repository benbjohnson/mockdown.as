package mockdown.display.flash
{
import mockdown.display.IRenderObject;
import mockdown.display.Stroke;
import mockdown.display.Fill;
import mockdown.display.SolidColorFill;
import mockdown.geom.Point;
import mockdown.geom.Rectangle;

import flash.display.Graphics;
import flash.display.Sprite;

/**
 *	This class renders to a Adobe Flash-based output.
 */
public class FlashRenderObject extends Sprite implements IRenderObject
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function FlashRenderObject()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Children
	//---------------------------------

	private var _children:Array = [];
	
	/**
	 *	The children of the render object in the display tree.
	 */
	public function get children():Array
	{
		return _children.slice();
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Dimensions
	//---------------------------------
	
	/**
	 *	@copy mockdown.display.IRenderOutput#move()
	 */
	public function move(x:int, y:int):void
	{
		this.x = x;
		this.y = y;
	}
	
	/**
	 *	@copy mockdown.display.IRenderOutput#resize()
	 */
	public function resize(width:uint, height:uint):void
	{
		//this.width  = width;
		//this.height = height;
	}


	//---------------------------------
	//	Drawing
	//---------------------------------
	
	/**
	 *	@copy mockdown.display.IRenderOutput#drawLine()
	 */
	public function drawLine(x1:int, y1:int, x2:int, y2:int, stroke:Stroke):void
	{
		setStrokeStyle(stroke);
		graphics.moveTo(x1, y1);
		graphics.lineTo(x2, y2);
	}

	/**
	 *	@copy mockdown.display.IRenderOutput#drawRect()
	 */
	public function drawRect(rect:Rectangle, stroke:Stroke, fill:Fill=null):void
	{
		setStrokeStyle(stroke);
		setFillStyle(fill);
		graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		graphics.endFill();
	}

	/**
	 *	@copy mockdown.display.IRenderOutput#clear()
	 */
	public function clear():void
	{
		graphics.clear();
	}
	
	/**
	 *	Begins a fill for a polygon.
	 */
	private function setStrokeStyle(stroke:Stroke):void
	{
		if(stroke) {
			graphics.lineStyle(stroke.thickness, stroke.color, stroke.alpha/100, true);
		}
		else {
			graphics.lineStyle(NaN);
		}
	}

	/**
	 *	Begins a fill for a polygon.
	 */
	private function setFillStyle(fill:Fill):void
	{
		// Solid color fill
		if(fill is SolidColorFill) {
			beginSolidColorFill(fill as SolidColorFill);
		}
	}

	/**
	 *	Begins a solid color fill for a polygon.
	 */
	private function beginSolidColorFill(fill:SolidColorFill):void
	{
		graphics.beginFill(fill.color, fill.alpha/100);
	}


	//---------------------------------
	//	Child Management
	//---------------------------------
	
	/**
	 *	@copy mockdown.display.IRenderOutput#addChild()
	 */
	public function addRenderChild(child:IRenderObject):void
	{
		// Exit if no child to add
		if(!(child is FlashRenderObject)) {
			return;
		}
		addChild(child as FlashRenderObject);
	}
	
	/**
	 *	@copy mockdown.display.IRenderOutput#removeChild()
	 */
	public function removeRenderChild(child:IRenderObject):void
	{
		// Exit if no child to remove
		if(!(child is FlashRenderObject)) {
			return;
		}
		
		// Remove from sprite children
		if(contains(child as FlashRenderObject)) {
			removeChild(child as FlashRenderObject);
		}
	}
	
	/**
	 *	@copy mockdown.display.IRenderOutput#removeAllChildren()
	 */
	public function removeAllRenderChildren():void
	{
		var n:int = numChildren;
		for(var i:int=0; i<n; i++) {
			removeChildAt(0);
		}
	}
}
}
