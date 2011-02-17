package mockdown.display.flash
{
import mockdown.components.Component;
import mockdown.display.RenderObject;
import mockdown.display.Stroke;
import mockdown.display.Fill;
import mockdown.display.SolidColorFill;
import mockdown.display.GradientFill;
import mockdown.geom.Point;
import mockdown.geom.Rectangle;

import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.geom.Matrix;

/**
 *	This class renders to a Adobe Flash-based output.
 */
public class FlashRenderObject extends Sprite implements RenderObject
{
	//--------------------------------------------------------------------------
	//
	//	Static Constants
	//
	//--------------------------------------------------------------------------

	/**
	 *	Used when calculating rounded corners.
	 */
	private static const SIN:Number = 0.292893218813453;

	/**
	 *	Used when calculating rounded corners.
	 */
	private static const TAN:Number = 0.585786437626905;


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
		graphics.beginFill(0, 0);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
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
		if(stroke) {
			graphics.moveTo(x1, y1);
			graphics.lineTo(x2, y2);
		}
	}

	/**
	 *	@copy mockdown.display.IRenderOutput#drawRect()
	 */
	public function drawRect(rect:Rectangle, stroke:Stroke, fill:Fill=null):void
	{
		// Ignore if no stroke or fill is provided
		if(!stroke && !fill) {
			return;
		}

		setStrokeStyle(stroke);
		setFillStyle(rect, fill);
		
		// Inset rectangle based on stroke thickness
		var thickness:uint = (stroke ? stroke.thickness : 0);
		
		// Determine dimensions
		var rx:int = rect.x+(thickness/2);
		var ry:int = rect.y+(thickness/2);
		var rw:int = rect.width-thickness;
		var rh:int = rect.height-thickness;

		graphics.drawRect(rx, ry, rw, rh);
		graphics.endFill();
	}

	/**
	 *	@copy mockdown.display.IRenderOutput#drawRect()
	 *
	 *	@private
	 *	This method is based on the Flex SDK GraphicUtil.drawRoundRectComplex()
	 *	method.
	 */
	public function drawBorderedBackground(component:Component, fill:Fill=null):void
	{
		// TODO: Refactor this out so that it does not use Component
		
		var w:Number = component.pixelWidth;
		var h:Number = component.pixelHeight;
		
		trace("w/h: + " + this + " -- " + w + ", " + h);
		
		// Determine dimensions
		var rx:int = component.borderLeftThickness/2;
		var ry:int = component.borderTopThickness/2;
		var rw:int = w-(component.borderRightThickness/2);
		var rh:int = h-(component.borderBottomThickness/2);

		// Constrain border radius
		var tl:uint = component.borderTopLeftRadius;
		var tr:uint = component.borderTopRightRadius;
		var bl:uint = component.borderBottomLeftRadius;
		var br:uint = component.borderBottomRightRadius;

		setFillStyle(new Rectangle(0, 0, w, h), fill);

        var min:Number = w < h ? w * 2 : h * 2;
        tl = Math.min(tl, min);
        tr = Math.min(tr, min);
        bl = Math.min(bl, min);
        br = Math.min(br, min);
        
        // Border - bottom
		setStrokeStyle(new Stroke(component.borderBottomColor, component.borderBottomAlpha, component.borderBottomThickness));
        graphics.moveTo(w, h - (br * TAN));
        graphics.curveTo(w - (br * TAN), h, w - br, h);
        graphics.lineTo(bl, h);
        graphics.curveTo(bl * TAN, h, bl * SIN, h - (bl * SIN));

        // Border - left
		setStrokeStyle(new Stroke(component.borderLeftColor, component.borderLeftAlpha, component.borderLeftThickness));
        graphics.curveTo(0, h - (bl * TAN), 0, h - bl);
        graphics.lineTo(0, tl);
        graphics.curveTo(0, tl * TAN, tl * SIN, tl * SIN);

		// Border - top
		setStrokeStyle(new Stroke(component.borderTopColor, component.borderTopAlpha, component.borderTopThickness));
        graphics.curveTo(tl * TAN, 0, tl, 0);
        graphics.lineTo(w - tr, 0);
        graphics.curveTo(w - (tr * TAN), 0, w - (tr * SIN), (tr * SIN));

		// Border - right
		setStrokeStyle(new Stroke(component.borderRightColor, component.borderRightAlpha, component.borderRightThickness));
        graphics.curveTo(w, (tr * TAN), w, tr);
        graphics.lineTo(w, h - br);
        graphics.curveTo(w, h - (br * TAN), w - (br * SIN), h - (br * SIN));

		// FIX: There is a problem with the bottom right corner rendering. It
		//      looks good enough for right now with a low corner radius.
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
		if(stroke && stroke.thickness > 0) {
			trace("  stroke: " + stroke.thickness + " : " + stroke.color);
			graphics.lineStyle(stroke.thickness, stroke.color, stroke.alpha/100, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
		}
		else {
			graphics.lineStyle(NaN);
		}
	}

	/**
	 *	Begins a fill for a polygon.
	 */
	private function setFillStyle(rect:Rectangle, fill:Fill):void
	{
		if(fill is SolidColorFill) {
			beginSolidColorFill(fill as SolidColorFill);
		}
		else if(fill is GradientFill) {
			beginGradientFill(rect, fill as GradientFill);
		}
	}

	private function beginSolidColorFill(fill:SolidColorFill):void
	{
		graphics.beginFill(fill.color, fill.alpha/100);
	}

	private function beginGradientFill(rect:Rectangle, fill:GradientFill):void
	{
		// Generate matrix for linear gradients
		var matrix:Matrix = new Matrix();
		if(fill.type == "radial") {
			matrix.createGradientBox(rect.width,  rect.height, 0, 0, 0);
		}
		else {
			matrix.createGradientBox(rect.width,  rect.height, fill.angle * (Math.PI/180));
		}

		// Convert alpha values to a value between 0 and 1
		var alphas:Array = fill.alphas.map(function(alpha:uint,...args):Number{return alpha/100});

		// Start the fill
		graphics.beginGradientFill(fill.type, fill.colors, alphas, null, matrix);
	}


	//---------------------------------
	//	Child Management
	//---------------------------------
	
	/**
	 *	@copy mockdown.display.IRenderOutput#addChild()
	 */
	public function addRenderChild(child:RenderObject):void
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
	public function removeRenderChild(child:RenderObject):void
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
