package mockdown.components.properties
{
import mockdown.components.Component;
import mockdown.components.Node;

import flash.errors.IllegalOperationError;

/**
 *	This class represents a function attached to a property on a component.
 */
public class FunctionProperty extends ComponentProperty
{
	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Creates a function property from a hash of options.
	 */
	static public function create(name:String, type:String, options:Object):FunctionProperty
	{
		return new FunctionProperty(name, options.functionReference as Function);
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
	public function FunctionProperty(name:String=null, functionReference:Function=null)
	{
		super(name, "function");
		this.functionReference = functionReference;
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
			throw new IllegalOperationError("Cannot set the type of a function property");
		}
		
		super.type = value;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Function Reference
	//---------------------------------
	
	private var _functionReference:Function;
	
	/**
	 *	A reference to the function that this property represents.
	 */
	public function get functionReference():Function
	{
		return _functionReference;
	}

	public function set functionReference(value:Function):void
	{
		verifyUnsealed();
		_functionReference = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/** @private */
	override public function parse(value:*):*
	{
		throw new IllegalOperationError("Setting values to a function is not allowed");
	}
}
}
