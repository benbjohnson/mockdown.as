package mockdown.errors
{
/**
 *	This class represents an error that has occurred during parsing.
 */
public class ParseError extends Error
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *
	 *	@param message  A string associated with the error object.
	 */
	public function ParseError(message:String="", lineNumber:int=0)
	{
		super(message);
		this.lineNumber = lineNumber;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The line number that the error occurred on.
	 */
	public var lineNumber:int = 0;
}
}
