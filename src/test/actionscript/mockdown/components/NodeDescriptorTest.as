package mockdown.components
{
import mockdown.components.properties.*;
import mockdown.test.*;

import asunit.framework.Assert;

public class NodeDescriptorTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var descriptor:NodeDescriptor;
	
	[Before]
	public function setup():void
	{
		descriptor = new NodeDescriptor();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Loader
	//---------------------------------

	[Test]
	public function shouldSetComponent():void
	{
		var component:Component = new Component();
		descriptor.component = component;
		Assert.assertEquals(component, descriptor.component);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingComponentWhenSealed():void
	{
		descriptor.seal();
		descriptor.component = new Component();
	}
	
	//---------------------------------
	//	Parent
	//---------------------------------

	[Test]
	public function shouldSetParent():void
	{
		var parent:NodeDescriptor = new NodeDescriptor();
		descriptor.parent = parent;
		Assert.assertEquals(parent, descriptor.parent);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorSettingParentWhenSealed():void
	{
		descriptor.seal();
		descriptor.parent = new NodeDescriptor();
	}
	
	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenCreatingCircularParentHiearchy():void
	{
		var x:NodeDescriptor = new NodeDescriptor();
		var y:NodeDescriptor = new NodeDescriptor();
		var z:NodeDescriptor = new NodeDescriptor();
		
		z.parent = y;
		y.parent = x;
		x.parent = z;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	Child management
	//---------------------------------

	[Test]
	public function shouldAddChild():void
	{
		var child:NodeDescriptor = new NodeDescriptor();
		descriptor.addChild(child);
		Assert.assertEquals(1, descriptor.children.length);
		Assert.assertEquals(child, descriptor.children[0]);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenAddingChildToSealedDescriptor():void
	{
		descriptor.seal();
		descriptor.addChild(new NodeDescriptor());
	}

	[Test]
	public function shouldRemoveChild():void
	{
		var child:NodeDescriptor = new NodeDescriptor();
		descriptor.addChild(child);
		descriptor.removeChild(child);
		Assert.assertEquals(0, descriptor.children.length);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenRemoveChildFromSealedDescriptor():void
	{
		descriptor.seal();
		descriptor.removeChild(new NodeDescriptor());
	}

	[Test]
	public function shouldRemoveAllChildren():void
	{
		descriptor.addChild(new NodeDescriptor());
		descriptor.addChild(new NodeDescriptor());
		descriptor.removeAllChildren();
		Assert.assertEquals(0, descriptor.children.length);
	}

	[Test(expects="flash.errors.IllegalOperationError")]
	public function shouldThrowErrorWhenRemovingAllChildrenFromSealedDescriptor():void
	{
		descriptor.seal();
		descriptor.removeAllChildren();
	}


	//---------------------------------
	//	Property values
	//---------------------------------

	[Test]
	public function shouldSetPropertyValue():void
	{
		descriptor.component = new Component();
		descriptor.component.addProperty(new StringProperty("foo"));

		descriptor.setPropertyValue("foo", "bar");
		Assert.assertEquals("bar", descriptor.getPropertyValue("foo"));
	}

	[Test]
	public function shouldThrowErrorWhenSettingPropertyWithNullName():void
	{
		descriptor.component = new Component();
		descriptor.component.addProperty(new StringProperty("foo"));

		assertThrowsWithMessage(ArgumentError, "Property name is required", function():void{
			descriptor.setPropertyValue(null, "bar");
		});
	}

	[Test]
	public function shouldThrowErrorWhenSettingPropertyWithNoAttachedComponent():void
	{
		assertThrowsWithMessage(ArgumentError, "Component is not attached to descriptor", function():void{
			descriptor.setPropertyValue("foo", "bar");
		});
	}

	[Test]
	public function shouldThrowErrorWhenSettingNonExistantProperty():void
	{
		descriptor.component = new Component();
		assertThrowsWithMessage(ArgumentError, "Property does not exist on component: foo", function():void{
			descriptor.setPropertyValue("foo", "bar");
		});
	}

	[Test]
	public function shouldThrowErrorWhenGettingPropertyWithNullName():void
	{
		assertThrowsWithMessage(ArgumentError, "Property name is required", function():void{
			descriptor.getPropertyValue(null);
		});
	}

	[Test]
	public function shouldGetProperty():void
	{
		var property:StringProperty = new StringProperty("foo");
		descriptor.component = new Component();
		descriptor.component.addProperty(property);
		Assert.assertEquals(property, descriptor.getProperty("foo"));
	}


	//---------------------------------
	//	Seal
	//---------------------------------

	[Test]
	public function shouldSeal():void
	{
		descriptor.seal();
		Assert.assertTrue(descriptor.sealed);
	}
}
}
