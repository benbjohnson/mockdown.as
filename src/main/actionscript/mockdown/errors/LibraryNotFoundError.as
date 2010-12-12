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
	 *	@param libraryName  The name of the library that is missing.
	 *	@param message      A string associated with the error object.
	 */
	public function LibraryNotFoundError(libraryName:String, message:String="")
	{
		super(message);
		this.libraryName = libraryName;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The name of the missing library.
	 */
	public var libraryName:String;
}
}
