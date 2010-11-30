package mockdown.display.flash
{
import mockdown.display.IRenderObject;

import flash.display.Graphics;

/**
 *	This class renders to a Adobe Flash-based output.
 */
public class FlashRenderObject implements IRenderObject
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
		_sprite = new Sprite();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Sprite
	//---------------------------------

	private var _sprite:Sprite;
	
	/**
	 *	The sprite used to render the output.
	 */
	public function get sprite():Sprite
	{
		return _sprite;
	}

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
	//	Drawing
	//---------------------------------
	
	/**
	 *	@copy mockdown.display.IRenderOutput#drawLine()
	 */
	public function drawLine(p1:Point, p2:Point, stroke:Stroke):void
	{
		var graphics:Graphics = sprite.graphics;
		setStrokeStyle(stroke);
		graphics.moveTo(p1.x, p1.y);
		graphics.lineTo(p2.x, p2.y);
	}

	/**
	 *	@copy mockdown.display.IRenderOutput#drawRect()
	 */
	public function drawRect(rect:Rectangle, radius:CornerRadius,
							 stroke:Stroke, fill:Fill):void
	{
		var graphics:Graphics = sprite.graphics;
		setStrokeStyle(stroke);
		setFillStyle(fill);
		graphics.moveTo(p1.x, p1.y);
		graphics.lineTo(p2.x, p2.y);
		graphics.endFill();
	}

	/**
	 *	@copy mockdown.display.IRenderOutput#clear()
	 */
	public function clear():void
	{
		sprite.graphics.clear();
	}
	
	/**
	 *	Begins a fill for a polygon.
	 */
	private function setStrokeStyle(stroke:Stroke):void
	{
		sprite.graphics.lineStyle(stroke.thickness, stroke.color, stroke.alpha/100);
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
		beginFill(fill.color, fill.alpha/100);
	}


	//---------------------------------
	//	Child Management
	//---------------------------------
	
	/**
	 *	@copy mockdown.display.IRenderOutput#addChild()
	 */
	public function addChild(child:IRenderObject):void
	{
		// Exit if no child to add
		if(!child) {
			return;
		}
		_children.push(child);
		sprite.addChild(child.sprite);
	}
	
	/**
	 *	@copy mockdown.display.IRenderOutput#removeChild()
	 */
	public function removeChild(child:IRenderObject):void
	{
		// Exit if no child to remove
		if(!child) {
			return;
		}
		
		// Remove from render children
		var index:int = _children.indexOf(child);
		if(index != -1) {
			_children.splice(index, 1);
		}
		
		// Remove from sprite children
		if(sprite.contains(child.sprite)) {
			sprite.removeChild(child.sprite);
		}
	}
	
	/**
	 *	@copy mockdown.display.IRenderOutput#removeAllChildren()
	 */
	public function removeAllChildren():void
	{
		var children:Array = this.children;
		for each(var child:IRenderObject in children) {
			removeChild(child);
		}
	}
}
}
