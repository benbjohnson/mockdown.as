package mockdown.components.properties
{
import mockdown.components.Component;
import mockdown.components.Node;

import flash.errors.IllegalOperationError;

/**
 *	This class represents a boolean property defined on a component.
 */
public class BooleanProperty extends ComponentProperty
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *	
	 *	@param name  The name of the property.
	 */
	public function BooleanProperty(name:String=null)
	{
		super(name, "boolean");
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/** @private */
	override public function set type(value:String):void
	{
		// Throw error if this has already been set
		if(type) {
			throw new IllegalOperationError("Cannot set the type of a boolean property");
		}
		
		super.type = value;
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/** @private */
	override public function parse(value:*):*
	{
		if(value == null) {
			return null;
		}
		else if(value is Boolean) {
			return value;
		}
		else if(value is String) {
			if(value == "true") {
				return true;
			}
			else if(value == "false") {
				return false;
			}
			else {
				throw new ArgumentError("Cannot parse string into boolean value: " + value);
			}
		}

		throw new ArgumentError("Cannot parse into boolean value: " + value);
	}
}
}
