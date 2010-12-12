package mockdown.components.definitions
{
/**
 *	This class represents a container that horizontally lays out its children.
 */
public class Row extends BaseComponent
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
		measureImplicit = row_measureImplicit;
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
	public var gap:int;
	
	
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
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Measurement
	//---------------------------------
	
	/**
	 *	Calculates the dimension of this node as the sum of its children.
	 */
	public var row_measureImplicit:Function = function():void
	{
		var child:*;
		
		// Calculate width as sum of child widths + padding + gaps
		if(this.width == null) {
			var pixelWidth:uint = 0;
			
			// Loop over children and determine size.
			for each(child in this.children) {
				pixelWidth += child.pixelWidth;
			}
			
			// Add left and right padding to width
			pixelWidth += this.paddingLeft + this.paddingRight;
			
			// Add gaps
			pixelWidth += this.gap * (this.children.length-1);
			
			this.pixelWidth = pixelWidth;
		}

		// Calculate height as the maximum child height + padding
		if(this.height == null) {
			var pixelHeight:uint = 0;

			// Loop over children and determine size.
			for each(child in this.children) {
				if(!isNaN(child.pixelHeight)) {
					pixelHeight = Math.max(pixelHeight, child.pixelHeight);
				}
			}
			
			// Add top and bottom padding to height
			pixelHeight += this.paddingTop + this.paddingBottom;
			
			this.pixelHeight = pixelHeight;
		}
	};

	//---------------------------------
	//	Layout
	//---------------------------------
	
	/** @private */
	public var layout:Function = function():void
	{
		layoutPercentChildren();
		layoutChildPositions();
	};
	
	/**
	 *	Lays out the variable width children.
	 */
	public var layoutPercentChildren:Function = function():void
	{
		var num:Number;
		var lastPercentChild:*;

		// Determine remaining width for percentages
		var totalChildExplicitWidth:Number = getTotalChildExplicitWidth();
		var totalChildPercentWidth:Number = getTotalChildPercentWidth();
		var totalGap:Number = this.gap * (this.children.length-1);
		var totalRemaining:int = this.pixelWidth - this.paddingLeft - this.paddingRight - totalChildExplicitWidth - totalGap;
		var remaining:int = totalRemaining;
		
		// Calculate percent width & height for children
		for each(var child:* in this.children) {
			// Calculate width based on percentage
			if(child.percentWidth != null) {
				// If there is width available, calculate percentage of it.
				if(totalRemaining > 0) {
					child.pixelWidth = Math.min(remaining, Math.round((child.percentWidth/totalChildPercentWidth) * totalRemaining));
					remaining -= child.pixelWidth;
					lastPercentChild = child;
				}
			}

			// Calculate height based on percentage
			if(child.percentHeight != null) {
				child.pixelHeight = (child.percentHeight/100) * this.pixelHeight;
			}
		}
		
		// If we have any remaining, add to the last percentage child
		if(lastPercentChild && remaining > 0) {
			lastPercentChild.pixelWidth += remaining;
		}
	};

	/**
	 *	Calculates the x and y position of each child.
	 */
	public var layoutChildPositions:Function = function():void
	{
		var child:*;
		var pos:int = 0;
		var total:int = this.gap * (this.children.length-1);
		
		// Determine total child width
		for each(child in this.children) {
			total += child.pixelWidth;
		}
		
		// Position children in a column.
		for each(child in this.children) {
			// X position
			if(this.align == "right") {
				child.x = this.pixelWidth - total - this.paddingRight + pos;
			}
			else if(this.align == "center") {
				// TODO: Include padding in calculation
				child.x = ((this.pixelWidth-this.paddingLeft-this.paddingRight)/2) - (total/2) + pos + this.paddingLeft;
			}
			else {
				child.x = this.paddingLeft + pos;
			}

			// Y position
			if(this.valign == "bottom") {
				child.y = this.pixelHeight - this.paddingBottom - child.pixelHeight;
			}
			else if(this.valign == "middle") {
				// TODO: Include padding in calculation
				child.y = ((this.pixelHeight-this.paddingTop-this.paddingBottom)/2) - (child.pixelHeight/2) + this.paddingTop;
			}
			else {
				child.y = this.paddingTop;
			}
			
			// Increment current position by child width and gap
			pos += child.pixelWidth + this.gap;
		}
	};


	//---------------------------------
	//	Utility
	//---------------------------------
	
	/**
	 *	The summed total width for all children that have a fixed width
	 *	specified.
	 */
	public var getTotalChildExplicitWidth:Function = function():Number
	{
		var total:uint = 0;
		
		for each(var child:* in this.children) {
			var num:Number = child.width;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	};

	/**
	 *	The summed total width for all children that have a percent width
	 *	specified.
	 */
	public var getTotalChildPercentWidth:Function = function():Number
	{
		var total:uint = 0;
		
		for each(var child:* in this.children) {
			var num:Number = child.percentWidth;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	};
}
}
