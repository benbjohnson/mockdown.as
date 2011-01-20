package mockdown.display.flash
{
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

		var tl:uint = rect.borderTopLeftRadius;
		var tr:uint = rect.borderTopRightRadius;
		var bl:uint = rect.borderBottomLeftRadius;
		var br:uint = rect.borderBottomRightRadius;

		// Draw rectangle
		if(tl || tr || bl || br) {
			drawRoundRect(rx, ry, rw, rh, tl, tr, bl, br);
		}
		else {
			graphics.drawRect(rx, ry, rw, rh);
		}
		graphics.endFill();
	}

	// This method is based on the Flex SDK GraphicUtil.drawRoundRectComplex()
	// method.
	private function drawRoundRect(x:int, y:int, width:uint, height:uint,
								  tl:uint, tr:uint, bl:uint, br:uint):void
	{
        var xw:Number = x + width;
        var yh:Number = y + height;
        
        var min:Number = width < height ? width * 2 : height * 2;
        tl = tl < min ? tl : min;
        tr = tr < min ? tr : min;
        bl = bl < min ? bl : min;
        br = br < min ? br : min;
        
        // bottom-right corner
        var a:Number = br * 0.292893218813453;
        var s:Number = br * 0.585786437626905;
        graphics.moveTo(xw, yh - br);
        graphics.curveTo(xw, yh - s, xw - a, yh - a);
        graphics.curveTo(xw - s, yh, xw - br, yh);
        
        // bottom-left corner
        a = bl * 0.292893218813453;
        s = bl * 0.585786437626905;
        graphics.lineTo(x + bl, yh);
        graphics.curveTo(x + s, yh, x + a, yh - a);
        graphics.curveTo(x, yh - s, x, yh - bl);
        
        // top-left corner
        a = tl * 0.292893218813453;
        s = tl * 0.585786437626905;
        graphics.lineTo(x, y + tl);
        graphics.curveTo(x, y + s, x + a, y + a);
        graphics.curveTo(x + s, y, x + tl, y);
        
        // top-right corner
        a = tr * 0.292893218813453;
        s = tr * 0.585786437626905;
        graphics.lineTo(xw - tr, y);
        graphics.curveTo(xw - s, y, xw - a, y + a);
        graphics.curveTo(xw, y + s, xw, y + tr);
        graphics.lineTo(xw, yh - br);
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
