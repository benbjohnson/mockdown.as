package mockdown.components.properties
{
import mockdown.components.Component;
import mockdown.components.Node;

import flash.errors.IllegalOperationError;

/**
 *	This class represents a string property defined on a component.
 */
public class StringProperty extends ComponentProperty
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
	public function StringProperty(name:String=null)
	{
		super(name, "string");
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
			throw new IllegalOperationError("Cannot set the type of a string property");
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

		return value.toString();
	}
}
}
