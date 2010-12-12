package mockdown.core
{
import mockdown.filesystem.File;

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
	public function Document(file:File=null)
	{
		super();
		this.file = file;
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	The file that the document was parsed from.
	 */
	public var file:File;
}
}
