package mockdown.display
{
import mockdown.components.StyleComponent;
import mockdown.geom.Point;
import mockdown.geom.Rectangle;

/**
 *	This interface declares basic drawing methods that can be used to render the
 *	components. The implementation depends on the type of output the render is
 *	meant to create.
 */
public interface RenderObject
{
	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Dimensions
	//---------------------------------

	/**
	 *	Moves the rendered display to the specified position relative to its
	 *	parent.
	 *
	 *	@param x  The x coordinate from the top-left corner of the parent.
	 *	@param y  The y coordinate from the top-left corner of the parent.
	 */
	function move(x:int, y:int):void;

	/**
	 *	Sets the size of the rendered display object.
	 *
	 *	@param width   The width of the display object.
	 *	@param height  The height of the display object.
	 */
	function resize(width:uint, height:uint):void;


	//---------------------------------
	//	Drawing
	//---------------------------------

	/**
	 *	Draws a line on the rendered output.
	 *
	 *	@param x1      The starting x coordinate to draw from.
	 *	@param y1      The starting y coordinate to draw from.
	 *	@param x2      The ending x coordinate to draw to.
	 *	@param y2      The ending y coordinate to draw to.
	 *	@param stroke  The style of stroke to use.
	 */
	function drawLine(x1:int, y1:int, x2:int, y2:int, stroke:Stroke):void;

	/**
	 *	Draws a rectangle on the rendered output.
	 *
	 *	@param rect    Specifies the position and size of the rectangle to draw.
	 *	@param stroke  The style of stroke to use.
	 *	@param fill    The style of fill to use.
	 */
	function drawRect(rect:Rectangle, stroke:Stroke, fill:Fill=null):void;

	/**
	 *	Draws a background with a border.
	 *
	 *	@param component  Specifies the styled component to draw.
	 *	@param fill       The style of fill to use.
	 */
	function drawBorderedBackground(component:StyleComponent, fill:Fill=null):void;

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
	function addRenderChild(child:RenderObject):void;

	/**
	 *	Removes a rendered child from this object.
	 *
	 *	@param child  The child to remove.
	 */
	function removeRenderChild(child:RenderObject):void;

	/**
	 *	Removes all rendered children from this object.
	 */
	function removeAllRenderChildren():void;
}
}
