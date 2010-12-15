package mockdown.components
{
/**
 *	This class represents a container that horizontally lays out its children.
 */
public dynamic class Row extends LayoutContainer
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
	//	Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Measurement
	//---------------------------------
	
	/**
	 *	Calculates the dimension of this node as the sum of its children
	 */
	override protected function measureImplicit():void
	{
		var child:Component;
		
		// Calculate width as sum of child widths + padding + gaps
		if(isNaN(width)) {
			var pixelWidth:uint = 0;
			
			// Loop over children and determine size.
			for each(child in _children) {
				if(!isNaN(child.pixelWidth)) {
					pixelWidth += child.pixelWidth;
				}
			}
			
			// Add left and right padding to width
			pixelWidth += paddingLeft + paddingRight;
			
			// Add gaps
			pixelWidth += gap * (_children.length-1);
			
			this.pixelWidth = pixelWidth;
		}

		// Calculate height as the maximum child height + padding
		if(isNaN(height)) {
			var pixelHeight:uint = 0;

			// Loop over children and determine size.
			for each(child in _children) {
				if(!isNaN(child.pixelHeight)) {
					pixelHeight = Math.max(pixelHeight, child.pixelHeight);
				}
			}
			
			// Add top and bottom padding to height
			pixelHeight += paddingTop + paddingBottom;
			
			this.pixelHeight = pixelHeight;
		}
	}
	

	//---------------------------------
	//	Layout
	//---------------------------------
	
	/** @private */
	override public function layout():void
	{
		layoutPercentChildren();
		layoutChildPositions();
	}
	
	/**
	 *	Lays out the variable width children.
	 */
	protected function layoutPercentChildren():void
	{
		var num:Number;
		var lastPercentChild:Component;

		// Determine remaining height for percentages
		var totalChildExplicitWidth:Number = getTotalChildExplicitWidth();
		var totalChildPercentWidth:Number = getTotalChildPercentWidth();
		var totalGap:Number = gap * (_children.length-1);
		var totalRemaining:int = pixelWidth - paddingLeft - paddingRight - totalChildExplicitWidth - totalGap;
		var remaining:int = totalRemaining;
		
		// Calculate percent width & height for children
		for each(var child:Component in _children) {
			// Calculate width based on percentage
			if(!isNaN(child.percentWidth)) {
				// If there is width available, calculate percentage of it.
				if(totalRemaining > 0) {
					child.pixelWidth = Math.min(remaining, Math.round((child.percentWidth/totalChildPercentWidth) * totalRemaining));
					remaining -= child.pixelWidth;
					lastPercentChild = child;
				}
			}

			// Calculate height based on percentage
			if(!isNaN(child.percentHeight)) {
				child.pixelHeight = (child.percentHeight/100) * pixelHeight;
			}
		}
		
		// If we have any remaining, add to the last percentage child
		if(lastPercentChild && remaining != 0) {
			lastPercentChild.pixelWidth += remaining;
		}
	}

	/**
	 *	Calculates the x and y position of each child.
	 */
	protected function layoutChildPositions():void
	{
		var child:Component;
		var pos:int = 0;
		var total:int = gap * (_children.length-1);
		
		// Determine total child width
		for each(child in _children) {
			total += child.pixelWidth;
		}
		
		// Position children in a column.
		for each(child in _children) {
			// X position
			if(align == "right") {
				child.x = pixelWidth - total - paddingRight + pos;
			}
			else if(align == "center") {
				child.x = ((pixelWidth-paddingLeft-paddingRight)/2) - (total/2) + pos + paddingLeft;
			}
			else {
				child.x = paddingLeft + pos;
			}

			// Y position
			if(valign == "bottom") {
				child.y = pixelHeight - paddingBottom - child.pixelHeight;
			}
			else if(valign == "middle") {
				child.y = ((pixelHeight-paddingTop-paddingBottom)/2) - (child.pixelHeight/2) + paddingTop;
			}
			else {
				child.y = paddingTop;
			}
			
			// Increment current position by child width and gap
			pos += child.pixelWidth + gap;
		}
	}


	//---------------------------------
	//	Utility
	//---------------------------------
	
	/**
	 *	The summed total width for all children that have a fixed width
	 *	specified.
	 */
	public function getTotalChildExplicitWidth():Number
	{
		var total:uint = 0;
		
		for each(var child:Component in _children) {
			var num:Number = child.width;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	}

	/**
	 *	The summed total width for all children that have a percent width
	 *	specified.
	 */
	public function getTotalChildPercentWidth():Number
	{
		var total:uint = 0;
		
		for each(var child:Component in _children) {
			var num:Number = child.percentWidth;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	}
}
}
