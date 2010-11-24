package mockdown.components
{
import mockdown.utils.StringUtil;

/**
 *	This class represents a container that horizontally lays out its children.
 */
public class Row extends VisualNode
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Row()
	{
		super();
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Gap
	//---------------------------------

	/**
	 *	The gap between children, in pixels.
	 */
	public var pixelGap:int;
	
	/**
	 *	The explicit gap between children.
	 */
	public var gap:String;
	
	
	//---------------------------------
	//	Alignment
	//---------------------------------

	/**
	 *	The horizontal alignment of the column children. Possible values are
	 *	<code>left<code>, <code>center<code> or <code>right</code>.
	 */
	public var align:String;

	/**
	 *	The vertical alignment of the column children. Possible values are
	 *	<code>top<code>, <code>middle<code> or <code>bottom</code>.
	 */
	public var valign:String;
	
	//---------------------------------
	//	Total child fixed width
	//---------------------------------
	
	/**
	 *	The summed total width for all children that have a fixed width
	 *	specified.
	 */
	public function getTotalChildExplicitWidth():Number
	{
		var total:uint = 0;
		
		for each(var child:VisualNode in visualChildren) {
			var num:Number = child.explicitWidth;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	}


	//---------------------------------
	//	Total child percent width
	//---------------------------------
	
	/**
	 *	The summed total width for all children that have a percent width
	 *	specified.
	 */
	public function getTotalChildPercentWidth():Number
	{
		var total:uint = 0;
		
		for each(var child:VisualNode in visualChildren) {
			var num:Number = child.percentWidth;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	}
	


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Measurement
	//---------------------------------
	
	/** @private */
	override public function measure():void
	{
		// Parse gap
		pixelGap = StringUtil.parseNumber(gap);
		
		super.measure();
	}
	
	/**
	 *	Calculates the dimension of this node as the sum of its children
	 */
	override protected function measureImplicit():void
	{
		var child:VisualNode;
		
		// Calculate width as sum of child widths + padding + gaps
		if(StringUtil.isEmpty(width)) {
			var pixelWidth:uint = 0;
			
			// Loop over children and determine size.
			for each(child in visualChildren) {
				if(!isNaN(child.pixelWidth)) {
					pixelWidth += child.pixelWidth;
				}
			}
			
			// Add left and right padding to width
			pixelWidth += pixelPaddingLeft + pixelPaddingRight;
			
			// Add gaps
			pixelWidth += pixelGap * (visualChildren.length-1);
			
			this.pixelWidth = pixelWidth;
		}

		// Calculate height as the maximum child height + padding
		if(StringUtil.isEmpty(height)) {
			var pixelHeight:uint = 0;

			// Loop over children and determine size.
			for each(child in visualChildren) {
				if(!isNaN(child.pixelHeight)) {
					pixelHeight = Math.max(pixelHeight, child.pixelHeight);
				}
			}
			
			// Add top and bottom padding to height
			pixelHeight += pixelPaddingTop + pixelPaddingBottom;
			
			this.pixelHeight = pixelHeight;
		}
	}

	//---------------------------------
	//	Layout
	//---------------------------------
	
	/** @private */
	override public function layout():void
	{
		super.layout();
		layoutPercentChildren();
		layoutChildPositions();
	}
	
	/**
	 *	Lays out the variable width children.
	 */
	protected function layoutPercentChildren():void
	{
		var num:Number;
		var lastPercentChild:VisualNode;

		// Determine remaining width for percentages
		var totalChildExplicitWidth:Number = getTotalChildExplicitWidth();
		var totalChildPercentWidth:Number = getTotalChildPercentWidth();
		var totalGap:Number = pixelGap * (visualChildren.length-1);
		var totalRemaining:int = pixelWidth - pixelPaddingLeft - pixelPaddingRight - totalChildExplicitWidth - totalGap;
		var remaining:int = totalRemaining;
		
		// Calculate percent width & height for children
		for each(var child:VisualNode in visualChildren) {
			// Calculate width based on percentage
			if(!isNaN(num = StringUtil.parsePercentage(child.width))) {
				// If there is width available, calculate percentage of it.
				if(totalRemaining > 0) {
					child.pixelWidth = Math.min(remaining, Math.round((num/totalChildPercentWidth) * totalRemaining));
					remaining -= child.pixelWidth;
					lastPercentChild = child;
				}
			}

			// Calculate height based on percentage
			if(!isNaN(num = StringUtil.parsePercentage(child.height))) {
				child.pixelHeight = (num/100) * pixelHeight;
			}
		}
		
		// If we have any remaining, add to the last percentage child
		if(lastPercentChild && remaining > 0) {
			lastPercentChild.pixelWidth += remaining;
		}
	}

	/**
	 *	Calculates the x and y position of each child.
	 */
	protected function layoutChildPositions():void
	{
		var child:VisualNode;
		var pos:int = 0;
		var total:int = pixelGap * (visualChildren.length-1);
		
		// Determine total child width
		for each(child in visualChildren) {
			total += child.pixelWidth;
		}
		
		// Position children in a column.
		for each(child in visualChildren) {
			// X position
			if(align == "right") {
				child.x = pixelWidth - total - pixelPaddingRight + pos;
			}
			else if(align == "center") {
				// TODO: Include padding in calculation
				child.x = ((pixelWidth-pixelPaddingLeft-pixelPaddingRight)/2) - (total/2) + pos + pixelPaddingLeft;
			}
			else {
				child.x = pixelPaddingLeft + pos;
			}

			// Y position
			if(valign == "bottom") {
				child.y = pixelHeight - pixelPaddingBottom - child.pixelHeight;
			}
			else if(valign == "middle") {
				// TODO: Include padding in calculation
				child.y = ((pixelHeight-pixelPaddingTop-pixelPaddingBottom)/2) - (child.pixelHeight/2) + pixelPaddingTop;
			}
			else {
				child.y = pixelPaddingTop;
			}
			
			// Increment current position by child width and gap
			pos += child.pixelWidth + pixelGap;
		}
	}
}
}
