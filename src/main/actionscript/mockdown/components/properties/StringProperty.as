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
	//	Static Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Creates a number property from a hash of options.
	 */
	static public function create(name:String, type:String, options:Object):StringProperty
	{
		var property:StringProperty = new StringProperty(name);

		if(options.defaultValue) {
			property.defaultValue = property.parse(options.defaultValue);
		}

		return property;
	}
	
	
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
		if(value == null || value == undefined) {
			return (nullable ? null : "");
		}

		return value.toString();
	}
}
}
