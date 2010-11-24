package mockdown.components
{
import mockdown.utils.StringUtil;

/**
 *	This class represents a container that vertically lays out its children.
 */
public class Column extends VisualNode
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Column()
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
	//	Total child fixed height
	//---------------------------------
	
	/**
	 *	The summed total height for all children that have a fixed height
	 *	specified.
	 */
	public function getTotalChildExplicitHeight():Number
	{
		var total:uint = 0;
		
		for each(var child:VisualNode in visualChildren) {
			var num:Number = child.explicitHeight;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	}


	//---------------------------------
	//	Total child percent height
	//---------------------------------
	
	/**
	 *	The summed total height for all children that have a percent height
	 *	specified.
	 */
	public function getTotalChildPercentHeight():Number
	{
		var total:uint = 0;
		
		for each(var child:VisualNode in visualChildren) {
			var num:Number = child.percentHeight;
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
		
		// Calculate width as the maximum child width + padding
		if(StringUtil.isEmpty(width)) {
			var pixelWidth:uint = 0;

			// Loop over children and determine size.
			for each(child in visualChildren) {
				if(!isNaN(child.pixelWidth)) {
					pixelWidth = Math.max(pixelWidth, child.pixelWidth);
				}
			}
			
			// Add left and right padding to width
			pixelWidth += pixelPaddingLeft + pixelPaddingRight;
			
			this.pixelWidth = pixelWidth;
		}

		// Calculate height as sum of child heights + padding + gaps
		if(StringUtil.isEmpty(height)) {
			var pixelHeight:uint = 0;
			
			// Loop over children and determine size.
			for each(child in visualChildren) {
				if(!isNaN(child.pixelHeight)) {
					pixelHeight += child.pixelHeight;
				}
			}
			
			// Add top and bottom padding to height
			pixelHeight += pixelPaddingTop + pixelPaddingBottom;
			
			// Add gaps
			pixelHeight += pixelGap * (visualChildren.length-1);
			
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
	 *	Lays out the variable height children.
	 */
	protected function layoutPercentChildren():void
	{
		var num:Number;
		var lastPercentChild:VisualNode;

		// Determine remaining height for percentages
		var totalChildExplicitHeight:Number = getTotalChildExplicitHeight();
		var totalChildPercentHeight:Number = getTotalChildPercentHeight();
		var totalGap:Number = pixelGap * (visualChildren.length-1);
		var totalRemaining:int = pixelHeight - pixelPaddingTop - pixelPaddingBottom - totalChildExplicitHeight - totalGap;
		var remaining:int = totalRemaining;
		
		// Calculate percent width & height for children
		for each(var child:VisualNode in visualChildren) {
			// Calculate height based on percentage
			if(!isNaN(num = StringUtil.parsePercentage(child.height))) {
				// If there is height available, calculate percentage of it.
				if(totalRemaining > 0) {
					child.pixelHeight = Math.min(remaining, Math.round((num/totalChildPercentHeight) * totalRemaining));
					remaining -= child.pixelHeight;
					lastPercentChild = child;
				}
			}

			// Calculate width based on percentage
			if(!isNaN(num = StringUtil.parsePercentage(child.width))) {
				child.pixelWidth = (num/100) * pixelWidth;
			}
		}
		
		// If we have any remaining, add to the last percentage child
		if(lastPercentChild && remaining > 0) {
			lastPercentChild.pixelHeight += remaining;
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
		
		// Determine total child height
		for each(child in visualChildren) {
			total += child.pixelHeight;
		}
		
		// Position children in a column.
		for each(child in visualChildren) {
			// X position
			if(align == "right") {
				child.x = pixelWidth - pixelPaddingRight - child.pixelWidth;
			}
			else if(align == "center") {
				// TODO: Include padding in calculation
				child.x = ((pixelWidth-pixelPaddingLeft-pixelPaddingRight)/2) - (child.pixelWidth/2) + pixelPaddingLeft;
			}
			else {
				child.x = pixelPaddingLeft;
			}
			
			// Y position
			if(valign == "bottom") {
				child.y = pixelHeight - total - pixelPaddingBottom + pos;
			}
			else if(valign == "middle") {
				child.y = ((pixelHeight-pixelPaddingTop-pixelPaddingBottom)/2) - (total/2) + pos + pixelPaddingTop;
			}
			else {
				child.y = pixelPaddingTop + pos;
			}

			// Increment current position by child height and gap
			pos += child.pixelHeight + pixelGap;
		}
	}
}
}
