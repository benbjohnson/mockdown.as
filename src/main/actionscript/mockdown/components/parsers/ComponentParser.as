package mockdown.components.parsers
{
import mockdown.components.BaseComponent;
import mockdown.components.ComponentDescriptor;
import mockdown.components.loaders.ComponentLoader;

/**
 *	This interface defines the methods for a parser for a component.
 */
public interface ComponentParser
{
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *	The loader used retrieve component definitions.
	 */
	function get loader():ComponentLoader;
	function set loader(value:ComponentLoader):void;
	

	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Parses Mockdown formatted content into a component descriptor.
	 *
	 *	@param content  The content to parse.
	 *
	 *	@return         The component defined by the content.
	 */
	function parse(content:String):ComponentDescriptor;
}
}
