package mockdown.errors
{
/**
 *	This class represents an error that is thrown when a requested library is
 *	not available.
 */
public class LibraryNotFoundError extends Error
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *
	 *	@param name     The name of the library that is missing.
	 *	@param message  A string associated with the error object.
	 */
	public function ParseError(name:String, message:String="")
	{
		super(message);
		this.name = name;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The name of the missing library.
	 */
	public var name:String;
}
}
