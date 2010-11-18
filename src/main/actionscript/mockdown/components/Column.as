package mockdown.components
{
import mockdown.utils.StringUtil;

/**
 *	This class represents a container that vertically lays out its children.
 */
public class Column extends Container
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
	
	private var _totalChildFixedHeight:Number;
	
	/**
	 *	The summed total height for all children that have a fixed height
	 *	specified.
	 */
	public function get totalChildFixedHeight():Number
	{
		var num:Number;
		
		if(isNaN(_totalChildFixedHeight)) {
			_totalChildFixedHeight = 0;
			
			for each(var child:VisualNode in visualChildren) {
				if(!isNaN(num = StringUtil.parseNumber(child.height))) {
					_totalChildFixedHeight += num;
				}
			}
		}

		return _totalChildFixedHeight;		
	}


	//---------------------------------
	//	Total child percent height
	//---------------------------------
	
	private var _totalChildPercentHeight:Number;
	
	/**
	 *	The summed total height for all children that have a percent height
	 *	specified.
	 */
	public function get totalChildPercentHeight():Number
	{
		var percent:Number;
		
		if(isNaN(_totalChildPercentHeight)) {
			_totalChildPercentHeight = 0;
			
			for each(var child:VisualNode in visualChildren) {
				if(!isNaN(percent = StringUtil.parsePercentage(child.height))) {
					_totalChildPercentHeight += percent;
				}
			}
		}

		return _totalChildPercentHeight;		
	}



	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Child management
	//---------------------------------

	/**
	 *	@private
	 */
	override public function addChild(child:Node):void
	{
		_totalChildPercentHeight = NaN;
		_totalChildFixedHeight   = NaN;
		super.addChild(child);
	}
	
	/**
	 *	@private
	 */
	override public function removeChild(child:Node):void
	{
		_totalChildPercentHeight = NaN;
		_totalChildFixedHeight   = NaN;
		super.removeChild(child);
	}


	//---------------------------------
	//	Measurement
	//---------------------------------
	
	/**
	 *	@inheritDoc
	 */
	override public function measure():void
	{
		super.measure();
		
		measureChildren();
		measureByChildSize();
	}


	/**
	 *	Measures the size for each of the direct children.
	 */
	protected function measureChildren():void
	{
		var num:Number;
		var child:VisualNode;
		var lastPercentChild:VisualNode;

		// Reset child pixel dimensions and measure children with unset height
		for each(child in visualChildren) {
			child.pixelWidth = child.pixelHeight = NaN;
			
			if(child.height == null) {
				child.measure();
			}
		}

		// Determine remaining height for percentages
		var totalRemaining:int = pixelHeight - pixelPaddingTop - pixelPaddingBottom - totalChildFixedHeight;
		var remaining:int = totalRemaining;
		
		// Calculate percent width & height for children
		for each(child in visualChildren) {
			// Calculate height based on percentage
			if(!isNaN(num = StringUtil.parsePercentage(child.height))) {
				// If there is height available, calculate percentage of it.
				if(totalRemaining > 0) {
					child.pixelHeight = Math.min(remaining, Math.round((num/totalChildPercentHeight) * totalRemaining));
					remaining -= child.pixelHeight;
					lastPercentChild = child;
				}
				else {
					child.pixelHeight = 0;
				}
			}
			// Determine fixed height
			else if(!isNaN(num = StringUtil.parseNumber(child.height))) {
				// If the children are larger than the parent then resize the children
				if(totalRemaining < 0) {
					var diff:Number = Math.max(remaining, Math.round((num/totalChildFixedHeight) * totalRemaining));
					child.pixelHeight = num + diff;
					remaining += diff;
				}
				// Otherwise just set the height of the child explicitly
				else {
					child.pixelHeight = num;
				}
			}
		}
		
		// If we have any remaining, add to the last percentage child
		if(lastPercentChild && remaining > 0) {
			lastPercentChild.pixelHeight += remaining;
		}

		// If we have any negative remaining, remove from the last fixed child
		if(child && remaining < 0) {
			child.pixelHeight += remaining;
		}
	}

	/**
	 *	Calculates the dimension of this node as the sum of its children
	 */
	protected function measureByChildSize():void
	{
		// TODO: Loop over children and determine size.
	}
}
}
