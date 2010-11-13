package mockdown.core
{
import flash.events.EventDispatcher;

/**
 *	This class represents context for nodes in the document to work within.
 */
public class Document extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function Document(filename:String=null)
	{
		super();
		this.filename = filename;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The filename that the document was parsed from.
	 */
	public var filename:String;
}
}
