package mockdown.components
{
import mockdown.components.properties.BooleanProperty;
import mockdown.components.properties.NumberProperty;
import mockdown.components.properties.StringProperty;
import asunit.framework.Assert;

public class NodeTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var node:Node;
	private var component:Component;
	
	[Before]
	public function setup():void
	{
		component = new Component();
		component.addProperty(new StringProperty("stringProperty"));
		component.addProperty(new NumberProperty("integerProperty", "int"));
		component.addProperty(new BooleanProperty("booleanProperty"));
		component.seal();
		
		node = new Node(component);
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function constructorShouldSetComponent():void
	{
		Assert.assertEquals(component, node.component);
	}

	[Test(expects="ArgumentError")]
	public function constructorShouldErrorIfComponentIsNull():void
	{
		node = new Node(null);
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Proxy
	//-----------------------------
	
	[Test]
	public function shouldAccessAndMutateStringProperty():void
	{
		node.stringProperty = "foo";
		Assert.assertEquals("foo", node.stringProperty);
	}
	
	[Test]
	public function shouldAccessAndMutateNumberProperty():void
	{
		node.integerProperty = "12";
		Assert.assertEquals(12, node.integerProperty);
	}
	
	[Test]
	public function shouldAccessAndMutateBooleanProperty():void
	{
		node.booleanProperty = "true";
		Assert.assertTrue(node.booleanProperty);
	}
	
	[Test(expects="ReferenceError")]
	public function shouldThrowErrorWhenSettingUndefinedProperty():void
	{
		node.no_such_property = "12";
	}
	
	[Test(expects="ReferenceError")]
	public function shouldThrowErrorWhenAccessingUndefinedProperty():void
	{
		var x:String = node.no_such_property;
	}
}
}