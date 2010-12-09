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
		trace("--> shouldAccessAndMutateStringProperty");
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


	//-----------------------------
	//  Children
	//-----------------------------

	[Test]
	public function shouldAddChild():void
	{
		var child:Node = new Node(component);
		node.addChild(child);
		Assert.assertEquals(child, node.children[0]);
	}

	[Test]
	public function shouldSetParentWhenAddingChild():void
	{
		var child:Node = new Node(component);
		node.addChild(child);
		Assert.assertEquals(node, child.parent);
	}

	[Test]
	public function shouldRemoveChild():void
	{
		var child:Node = new Node(component);
		node.addChild(child);
		node.removeChild(child);
		Assert.assertEquals(0, node.children.length);
	}

	[Test]
	public function shouldUnsetParentWhenRemovingChild():void
	{
		var child:Node = new Node(component);
		node.addChild(child);
		node.removeChild(child);
		Assert.assertNull(child.parent);
	}
}
}