package mockdown.components.parsers
{
import mockdown.components.ComponentDescriptor;
import mockdown.components.loaders.ComponentLoader;

import org.mock4as.Mock;

public class MockComponentParser extends Mock implements ComponentParser
{
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//---------------------------------
	//	Loader
	//---------------------------------

	private var _loader:ComponentLoader;

	/**
	 *	@copy ComponentParser#loader
	 */
	public function get loader():ComponentLoader
	{
		return _loader;
	}

	public function set loader(value:ComponentLoader):void
	{
		_loader = value;
	}
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	public function parse(content:String):ComponentDescriptor
	{
		record("parse", content);
		return expectedReturnFor("parse") as ComponentDescriptor;
	}
}
}
