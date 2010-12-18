package mockdown.core
{
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import flash.utils.describeType;

/**
 * 	This class creates a metadata structure of a class that is specific to
 *	Mockdown.
 */		
public class Type
{
	//--------------------------------------------------------------------------
	//
	//	Static Constants
	//
	//--------------------------------------------------------------------------

	/**
	 *	A flag stating that the access of a property is readable.
	 */
	static public const READABLE:int = 1;
	
	/**
	 *	A flag stating that the access of a property is writable.
	 */
	static public const WRITABLE:int = 2;


	/**
	 *	The available data types.
	 */
	static public const DATA_TYPES:Object = ["string", "boolean", "decimal", "int", "uint"];

	/**
	 *	The conversion lookup of ActionScript types to Mockdown types.
	 */
	static public const ACTION_SCRIPT_DATA_TYPES:Object = {
		"String":"string",
		"Boolean":"boolean",
		"Number":"decimal",
		"int":"int",
		"uint":"uint"
	};
	

	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	A lookup of cached meta data.
	 */
	static private var cache:Dictionary = new Dictionary();
	

	//--------------------------------------------------------------------------
	//
	//	Static Methods
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Meta data
	//---------------------------------

	/**
	 *	Generates the meta data for a given class.
	 * 
	 *	@param clazz  The class to generate meta data for.
	 *
	 *	@returns      A object describing the meta data of the object.
	 */			
	static public function describe(clazz:Class):Object
	{
		var meta:Object = cache[clazz];
		
		// If class meta data is not cached, generate it
		if(meta == null) {
			// Create new meta object
			meta = {};
			
			// Retrieve XML meta data
			var xml:XML = describeType(clazz);
			
			// Describe properties
			var propertyXmlLists:Array = [xml..accessor, xml..variable];
			for each(var propertyXmlList:XMLList in propertyXmlLists) {
				for each(var propertyXml:XML in propertyXmlList) {
					var property:Object = parseProperty(propertyXml);
					if(property) {
						meta[property.name] = property;
					}
				}
			}
			
			// Cache meta data
			cache[clazz] = meta;
		}
		
		return meta;
	}
	
	/**
	 *	Parses individual properties from XML descriptors.
	 */
	static private function parseProperty(xml:XML):Object
	{
		// Parse type
		var type:String = ACTION_SCRIPT_DATA_TYPES[xml.@type.toString()];
		
		// Parse access type
		var access:String = xml.@access.toString();
		var readable:Boolean = (access == null || access == "readonly" || access == "readwrite");
		var writable:Boolean = (access == null || access == "writeonly" || access == "readwrite");
		
		var property:Object = {};
		property.name   = xml.@name.toString();
		property.type   = type;
		property.access = (readable ? READABLE : 0) | (writable ? WRITABLE : 0);

		// Parse meta tags
		var meta:Object = parseMeta(xml);
		property.meta = meta;
		
		// Retrieve data type from Property meta tag
		if(meta.Property && meta.Property.type) {
			// Check that it is a valid type
			if(DATA_TYPES.indexOf(meta.Property.type) == -1) {
				throw new IllegalOperationError("Invalid type: " + meta.Property.type);
			}
			
			property.type = meta.Property.type;
		}

		// Return null if we don't have a valid type
		if(!property.type) {
			return null;
		}
		
		// Continue parsing meta data
		if(meta.Property) {
			// Default value
			if(meta.Property.defaultValue) {
				property.defaultValue = meta.Property.defaultValue;
			}

			// Percent field
			if(meta.Property.percentField) {
				property.percentField = meta.Property.percentField;
			}
		}
		
		return property;
	}

	/**
	 *	Parses metadata from XML.
	 */
	static private function parseMeta(xml:XML):Object
	{
		var meta:Object = {};
		for each(var metadataXml:XML in xml.metadata) {
			var name:String = metadataXml.@name.toString();

			// Hide names that start with an underscore and don't override
			// meta tags that have already been parsed.
			if(name.charAt(0) != "_" && meta[name] == null) {
				var args:Object = {};
				for each(var argXml:XML in metadataXml.arg) {
					args[argXml.@key.toString()] = argXml.@value.toString();
				}
				meta[name] = args;
			}
		}
		return meta;
	}
}
}