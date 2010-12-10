package mockdown.components.definitions
{
import mockdown.utils.StringUtil;

/**
 *	This class represents a container that vertically lays out its children.
 */
public class Column extends BaseComponent
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
		
		measureImplicit = column_measureImplicit;
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
	 *	Calculates the dimension of this node as the sum of its children
	 */
	public var column_measureImplicit:Function = function():void
	{
		var child:*;
		
		// Calculate width as the maximum child width + padding
		if(this.width == null) {
			var pixelWidth:uint = 0;

			// Loop over children and determine size.
			for each(child in this.children) {
				if(!isNaN(child.pixelWidth)) {
					pixelWidth = Math.max(pixelWidth, child.pixelWidth);
				}
			}
			
			// Add left and right padding to width
			pixelWidth += this.paddingLeft + this.paddingRight;
			
			this.pixelWidth = pixelWidth;
		}

		// Calculate height as sum of child heights + padding + gaps
		if(this.height == null) {
			var pixelHeight:uint = 0;
			
			// Loop over children and determine size.
			for each(child in this.children) {
				if(!isNaN(child.pixelHeight)) {
					pixelHeight += child.pixelHeight;
				}
			}
			
			// Add top and bottom padding to height
			pixelHeight += this.paddingTop + this.paddingBottom;
			
			// Add gaps
			pixelHeight += this.gap * (this.children.length-1);
			
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
	 *	Lays out the variable height children.
	 */
	public var layoutPercentChildren:Function = function():void
	{
		var num:Number;
		var lastPercentChild:*;

		// Determine remaining height for percentages
		var totalChildExplicitHeight:Number = getTotalChildExplicitHeight();
		var totalChildPercentHeight:Number = getTotalChildPercentHeight();
		var totalGap:Number = this.gap * (this.children.length-1);
		var totalRemaining:int = this.pixelHeight - this.paddingTop - this.paddingBottom - totalChildExplicitHeight - totalGap;
		var remaining:int = totalRemaining;
		
		// Calculate percent width & height for children
		for each(var child:* in this.children) {
			// Calculate height based on percentage
			if(child.percentHeight != null) {
				// If there is height available, calculate percentage of it.
				if(totalRemaining > 0) {
					child.pixelHeight = Math.min(remaining, Math.round((child.percentHeight/totalChildPercentHeight) * totalRemaining));
					remaining -= child.pixelHeight;
					lastPercentChild = child;
				}
			}

			// Calculate width based on percentage
			if(child.percentWidth != null) {
				child.pixelWidth = (child.percentWidth/100) * this.pixelWidth;
			}
		}
		
		// If we have any remaining, add to the last percentage child
		if(lastPercentChild && remaining > 0) {
			lastPercentChild.pixelHeight += remaining;
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
		
		// Determine total child height
		for each(child in this.children) {
			total += child.pixelHeight;
		}
		
		// Position children in a column.
		for each(child in this.children) {
			// X position
			if(this.align == "right") {
				child.x = this.pixelWidth - this.paddingRight - child.pixelWidth;
			}
			else if(this.align == "center") {
				// TODO: Include padding in calculation
				child.x = ((this.pixelWidth-this.paddingLeft-this.paddingRight)/2) - (child.pixelWidth/2) + this.paddingLeft;
			}
			else {
				child.x = this.paddingLeft;
			}
			
			// Y position
			if(this.valign == "bottom") {
				child.y = this.pixelHeight - total - this.paddingBottom + pos;
			}
			else if(this.valign == "middle") {
				child.y = ((this.pixelHeight-this.paddingTop-this.paddingBottom)/2) - (total/2) + pos + this.paddingTop;
			}
			else {
				child.y = this.paddingTop + pos;
			}

			// Increment current position by child height and gap
			pos += child.pixelHeight + this.gap;
		}
	};


	//---------------------------------
	//	Utility
	//---------------------------------
	
	/**
	 *	The summed total height for all children that have a fixed height
	 *	specified.
	 */
	public var getTotalChildExplicitHeight:Function = function():Number
	{
		var total:uint = 0;
		
		for each(var child:* in this.children) {
			var num:Number = child.height;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	};

	/**
	 *	The summed total height for all children that have a percent height
	 *	specified.
	 */
	public var getTotalChildPercentHeight:Function = function():Number
	{
		var total:uint = 0;
		
		for each(var child:* in this.children) {
			var num:Number = child.percentHeight;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	};
}
}
