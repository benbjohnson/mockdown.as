package mockdown.display
{
import mockdown.geom.Point;
import mockdown.geom.Rectangle;

/**
 *	This interface declares basic drawing methods that can be used to render the
 *	nodes. The implementation depends on the type of output the render is meant
 *	to create.
 */
public interface IRenderObject
{
	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Drawing
	//---------------------------------

	/**
	 *	Draws a line on the rendered output.
	 *
	 *	@param p1      The starting point to draw from.
	 *	@param p2      The ending point to draw to.
	 *	@param stroke  The style of stroke to use.
	 */
	function drawLine(p1:Point, p2:Point, stroke:Stroke):void;

	/**
	 *	Draws a rectangle on the rendered output.
	 *
	 *	@param rect    Specifies the position and size of the rectangle to draw.
	 *	@param stroke  The style of stroke to use.
	 *	@param fill    The style of fill to use.
	 */
	function drawRect(rect:Rectangle, stroke:Stroke, fill:Fill):void;

	/**
	 *	Clears all previous drawing from the rendered output.
	 */
	function clear():void;



	//---------------------------------
	//	Child Management
	//---------------------------------

	/**
	 *	Adds a rendered child to this object.
	 *
	 *	@param child  The child to add.
	 */
	function addChild(child:IRenderObject):void;

	/**
	 *	Removes a rendered child from this object.
	 *
	 *	@param child  The child to remove.
	 */
	function removeChild(child:IRenderObject):void;

	/**
	 *	Removes all rendered children from this object.
	 */
	function removeAllChildren():void;
}
}
