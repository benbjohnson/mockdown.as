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
	
	/**
	 *	Calculates the dimension of this node as the sum of its children
	 */
	override protected function measureImplicit():void
	{
		var child:VisualNode;
		
		// Calculate height as sum of child heights
		if(height == null) {
			// Loop over children and determine size.
			for each(child in visualChildren) {
				if(!isNaN(child.pixelHeight)) {
					pixelHeight += child.pixelHeight;
				}
			}
			
			// Add top and bottom padding to height
			pixelHeight += pixelPaddingTop + pixelPaddingBottom;
			
			this.pixelHeight = pixelHeight;
		}
		
		// Calculate width as the maximum child width
		if(width == null) {
			// Loop over children and determine size.
			for each(child in visualChildren) {
				if(!isNaN(child.pixelWidth)) {
					pixelWidth = Math.max(pixelWidth, child.pixelHeight);
				}
			}
			
			// Add left and right padding to width
			pixelWidth += pixelPaddingLeft + pixelPaddingLeft;
			
			this.pixelWidth = pixelWidth;
		}
		
	}

	//---------------------------------
	//	Layout
	//---------------------------------
	
	/** @private */
	override public function layout():void
	{
		var num:Number;
		var lastPercentChild:VisualNode;

		// Determine remaining height for percentages
		var totalChildExplicitHeight:Number = getTotalChildExplicitHeight();
		var totalChildPercentHeight:Number = getTotalChildPercentHeight();
		var totalRemaining:int = pixelHeight - pixelPaddingTop - pixelPaddingBottom - totalChildExplicitHeight;
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
		}
		
		// If we have any remaining, add to the last percentage child
		if(lastPercentChild && remaining > 0) {
			lastPercentChild.pixelHeight += remaining;
		}
	}
}
}
