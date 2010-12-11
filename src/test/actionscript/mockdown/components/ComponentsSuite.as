package mockdown.components
{
import mockdown.components.definitions.ComponentDefinitionsSuite;
import mockdown.components.loaders.ComponentLoadersSuite;
import mockdown.components.properties.ComponentPropertiesSuite;

[Suite]
public class ComponentsSuite
{
	public var s0:ComponentLoadersSuite;
	public var s1:ComponentPropertiesSuite;
	public var s2:ComponentDefinitionsSuite;

	public var t0:ActionScriptComponentTest;
	public var t1:ComponentTest;
	public var t2:NodeTest;
	public var t3:NodeDescriptorTest;

	/*
	public var t0:ColumnTest;
	public var t1:RowTest;
	public var t2:VisualNodeTest;
	*/
}
}