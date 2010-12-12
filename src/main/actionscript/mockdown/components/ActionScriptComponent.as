package mockdown.components
{
import mockdown.components.loaders.ComponentLoader;
import mockdown.components.properties.BooleanProperty;
import mockdown.components.properties.ComponentProperty;
import mockdown.components.properties.FunctionProperty;
import mockdown.components.properties.NumberProperty;
import mockdown.components.properties.StringProperty;

import flash.errors.IllegalOperationError;
import flash.utils.describeType;

/**
 *	This class uses reflection to extract the definition of a component from
 *	an ActionScript class.
 */
public class ActionScriptComponent extends Component
{
	//--------------------------------------------------------------------------
	//
	//	Static Constants
	//
	//--------------------------------------------------------------------------
	
	private const PROPERTY_TYPES:Object = {
		"string":  StringProperty,
		"int":     NumberProperty,
		"uint":    NumberProperty,
		"decimal": NumberProperty,
		"boolean": BooleanProperty
	};
	
	
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function ActionScriptComponent(name:String, clazz:Class, parent:Component=null)
	{
		super(name, parent);
		
		// Require class reference
		if(clazz == null) {
			throw new ArgumentError("Class is required for creating an ActionScript-based component");
		}
		
		_clazz = clazz;
		instance = new clazz();
		
		initialize();
	}
	
	
	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	
	//---------------------------------
	//	Internal
	//---------------------------------

	/**
	 *	An instance of the class used by this component.
	 */
	private var instance:Object;

	
	//---------------------------------
	//	Class
	//---------------------------------
	
	private var _clazz:Class;
	
	/**
	 *	The underlying ActionScript class that the component definition is
	 *	derived from.
	 */
	public function get clazz():Class
	{
		return _clazz;
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Uses reflection to find all properties on the class and associate them
	 *	to the component.
	 */
	protected function initialize():void
	{
		var typeXml:XML = describeType(clazz);
		
		// Loop over properties and extract component properties & methods
		for each(var variableXml:XML in typeXml..variable) {
			var name:String = variableXml.@name;
			var type:String = variableXml.@type;
			var meta:Object = getMetaData(variableXml);
			
			// Implicitly determine type if nothing is defined
			if(!meta.Property && !meta.Function) {
				if(type == "Function") {
					meta.Function = {};
				}
				else {
					meta.Property = {type:type.toLowerCase()};
				}
			}
			
			// Add a property
			if(meta.Property) {
				meta.Property.type ||= type.toLowerCase();
				var property:ComponentProperty = createComponentProperty(name, meta.Property);
				addProperty(property);
			}
			// Add a function
			else if(meta.Function) {
				if(type != "Function") {
					throw new IllegalOperationError("A Function property must be defined as a Function in ActionScript");
				}
				
				meta.Function.functionReference = instance[name] as Function;
				var functionProperty:FunctionProperty = FunctionProperty.create(name, "function", meta.Function);
				addProperty(functionProperty);
			}
		}
	}
	
	private function getMetaData(xml:XML):Object
	{
		var data:Object = {};
		for each(var metadataXml:XML in xml.metadata) {
			var name:String = metadataXml.@name;
			var args:Object = {};
			for each(var argXml:XML in metadataXml.arg) {
				args[argXml.@key] = argXml.@value.toString();
			}
			data[name] = args;
		}
		return data;
	}

	private function createComponentProperty(name:String, meta:Object):ComponentProperty
	{
		var type:String = meta.type || "string";
		var propertyClass:Class = PROPERTY_TYPES[type];
		
		// Throw error if type does not exist
		if(propertyClass == null) {
			throw new IllegalOperationError("Type does not exist: " + type);
		}
		
		// Create property
		return propertyClass['create'](name, type, meta) as ComponentProperty;
	}
}
}
