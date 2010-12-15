package mockdown.components
{
/**
 *	This class represents a container that vertically lays out its children.
 */
public dynamic class Column extends Component
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
	override protected function measureImplicit():void
	{
		var child:Component;
		
		// Calculate width as the maximum child width + padding
		if(isNaN(width)) {
			var pixelWidth:uint = 0;

			// Loop over children and determine size.
			for each(child in _children) {
				if(!isNaN(child.pixelWidth)) {
					pixelWidth = Math.max(pixelWidth, child.pixelWidth);
				}
			}
			
			// Add left and right padding to width
			pixelWidth += paddingLeft + paddingRight;
			
			this.pixelWidth = pixelWidth;
		}

		// Calculate height as sum of child heights + padding + gaps
		if(isNaN(height)) {
			var pixelHeight:uint = 0;
			
			// Loop over children and determine size.
			for each(child in _children) {
				if(!isNaN(child.pixelHeight)) {
					pixelHeight += child.pixelHeight;
				}
			}
			
			// Add top and bottom padding to height
			pixelHeight += paddingTop + paddingBottom;
			
			// Add gaps
			pixelHeight += gap * (_children.length-1);
			
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
	 *	Lays out the variable height children.
	 */
	protected function layoutPercentChildren():void
	{
		var num:Number;
		var lastPercentChild:Component;

		// Determine remaining height for percentages
		var totalChildExplicitHeight:Number = getTotalChildExplicitHeight();
		var totalChildPercentHeight:Number = getTotalChildPercentHeight();
		var totalGap:Number = gap * (_children.length-1);
		var totalRemaining:int = pixelHeight - paddingTop - paddingBottom - totalChildExplicitHeight - totalGap;
		var remaining:int = totalRemaining;
		
		// Calculate percent width & height for children
		for each(var child:Component in _children) {
			// Calculate height based on percentage
			if(!isNaN(child.percentHeight)) {
				// If there is height available, calculate percentage of it.
				if(totalRemaining > 0) {
					child.pixelHeight = Math.min(remaining, Math.round((child.percentHeight/totalChildPercentHeight) * totalRemaining));
					remaining -= child.pixelHeight;
					lastPercentChild = child;
				}
			}

			// Calculate width based on percentage
			if(!isNaN(child.percentWidth)) {
				child.pixelWidth = (child.percentWidth/100) * pixelWidth;
			}
		}
		
		// If we have any remaining, add to the last percentage child
		if(lastPercentChild && remaining != 0) {
			lastPercentChild.pixelHeight += remaining;
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
		
		// Determine total child height
		for each(child in _children) {
			total += child.pixelHeight;
		}
		
		// Position children in a column.
		for each(child in _children) {
			// X position
			if(align == "right") {
				child.x = pixelWidth - paddingRight - child.pixelWidth;
			}
			else if(align == "center") {
				child.x = ((pixelWidth-paddingLeft-paddingRight)/2) - (child.pixelWidth/2) + paddingLeft;
			}
			else {
				child.x = paddingLeft;
			}
			
			// Y position
			if(valign == "bottom") {
				child.y = pixelHeight - total - paddingBottom + pos;
			}
			else if(valign == "middle") {
				child.y = ((pixelHeight-paddingTop-paddingBottom)/2) - (total/2) + pos + paddingTop;
			}
			else {
				child.y = paddingTop + pos;
			}

			// Increment current position by child height and gap
			pos += child.pixelHeight + gap;
		}
	}


	//---------------------------------
	//	Utility
	//---------------------------------
	
	/**
	 *	The summed total height for all children that have a fixed height
	 *	specified.
	 */
	public function getTotalChildExplicitHeight():Number
	{
		var total:uint = 0;
		
		for each(var child:Component in _children) {
			var num:Number = child.height;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	}

	/**
	 *	The summed total height for all children that have a percent height
	 *	specified.
	 */
	public function getTotalChildPercentHeight():Number
	{
		var total:uint = 0;
		
		for each(var child:Component in _children) {
			var num:Number = child.percentHeight;
			total += !isNaN(num) ? num : 0;
		}

		return total;
	}
}
}
