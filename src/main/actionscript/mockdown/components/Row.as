package mockdown.components
{
import mockdown.utils.StringUtil;

/**
 *	This class represents a container that horizontally lays out its children.
 */
public class Row extends Container
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
	//	Total child fixed width
	//---------------------------------
	
	private var _totalChildFixedWidth:Number;
	
	/**
	 *	The summed total width for all children that have a fixed width
	 *	specified.
	 */
	public function get totalChildFixedWidth():Number
	{
		var num:Number;
		
		if(isNaN(_totalChildFixedWidth)) {
			_totalChildFixedWidth = 0;
			
			for each(var child:VisualNode in visualChildren) {
				if(!isNaN(num = StringUtil.parseNumber(child.width))) {
					_totalChildFixedWidth += num;
				}
			}
		}

		return _totalChildFixedWidth;		
	}


	//---------------------------------
	//	Total child percent width
	//---------------------------------
	
	private var _totalChildPercentWidth:Number;
	
	/**
	 *	The summed total width for all children that have a percent width
	 *	specified.
	 */
	public function get totalChildPercentWidth():Number
	{
		var percent:Number;
		
		if(isNaN(_totalChildPercentWidth)) {
			_totalChildPercentWidth = 0;
			
			for each(var child:VisualNode in visualChildren) {
				if(!isNaN(percent = StringUtil.parsePercentage(child.width))) {
					_totalChildPercentWidth += percent;
				}
			}
		}

		return _totalChildPercentWidth;		
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	@private
	 */
	override public function addChild(child:Node):void
	{
		_totalChildPercentWidth = NaN;
		_totalChildFixedWidth   = NaN;
		super.addChild(child);
	}
	
	/**
	 *	@private
	 */
	override public function removeChild(child:Node):void
	{
		_totalChildPercentWidth = NaN;
		_totalChildFixedWidth   = NaN;
		super.removeChild(child);
	}
}
}
