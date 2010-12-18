package mockdown.components
{
import mockdown.test.*;

import asunit.framework.Assert;

import flash.errors.IllegalOperationError;

public class ComponentDescriptorTest
{
	//--------------------------------------------------------------------------
	//
	//	Setup
	//
	//--------------------------------------------------------------------------

	private var descriptor:ComponentDescriptor;
	
	[Before]
	public function setup():void
	{
		descriptor = new ComponentDescriptor(Component);
	}
	

	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	[Test]
	public function constructorShouldSetParent():void
	{
		Assert.assertEquals(Component, descriptor.parent);
	}


	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------

	//-----------------------------
	//  Parent
	//-----------------------------

	[Test]
	public function shouldSetParentToClass():void
	{
		descriptor.parent = Row;
		Assert.assertEquals(Row, descriptor.parent);
	}

	[Test]
	public function shouldSetMetaWhenParentIsClass():void
	{
		descriptor.parent = Row;
		Assert.assertNotNull(descriptor.meta);
	}

	[Test]
	public function shouldSetParentToDescriptor():void
	{
		var parent:ComponentDescriptor = new ComponentDescriptor();
		descriptor.parent = parent;
		Assert.assertEquals(parent, descriptor.parent);
	}

	[Test]
	public function shouldCopyMetaFromParentDescriptor():void
	{
		var parent:ComponentDescriptor = new ComponentDescriptor();
		parent.meta = {};
		descriptor.parent = parent;
		Assert.assertEquals(parent.meta, descriptor.meta);
	}

	[Test]
	public function shouldSetParentToNull():void
	{
		descriptor.parent = null;
		Assert.assertNull(descriptor.parent);
	}

	[Test]
	public function shouldThrowErrorWhenSettingParentToNonClassOrDescriptor():void
	{
		assertThrowsWithMessage(ArgumentError, "Descriptor parent must be a class or another descriptor", function():void{
			descriptor.parent = {};
		});
	}

	[Test]
	public function shouldThrowErrorWhenCreatingCircularParentHierarchy():void
	{
		var a:ComponentDescriptor = new ComponentDescriptor();
		var b:ComponentDescriptor = new ComponentDescriptor();
		var c:ComponentDescriptor = new ComponentDescriptor();
		
		a.parent = b;
		b.parent = c;

		assertThrowsWithMessage(IllegalOperationError, "Cannot create circular parent descriptor hierarchy", function():void{
			c.parent = a;
		});
	}


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	//-----------------------------
	//  Factory
	//-----------------------------

	[Test]
	public function shouldCreateComponentFromParentClass():void
	{
		Assert.assertTrue(descriptor.newInstance() is Component);
	}

	[Test]
	public function shouldCreateComponentFromParentDescriptor():void
	{
		var child:ComponentDescriptor = new ComponentDescriptor(descriptor);
		Assert.assertTrue(child.newInstance() is Component);
	}

	[Test]
	public function shouldThrowErrorWhenInstantiatingWithoutAParent():void
	{
		descriptor.parent = null;
		assertThrowsWithMessage(IllegalOperationError, "Cannot create new instance from descriptor when missing parent", function():void{
			descriptor.newInstance();
		});
	}

	[Test]
	public function shouldCreateComponentWithValues():void
	{
		descriptor.values = {x:10, y:20};
		
		var component:Component = descriptor.newInstance();
		Assert.assertEquals(10, component.x);
		Assert.assertEquals(20, component.y);
	}

	[Test]
	public function shouldCreateComponentWithChildren():void
	{
		var a:ComponentDescriptor  = new ComponentDescriptor(Component);
		var b:ComponentDescriptor  = new ComponentDescriptor(Component);
		var ba:ComponentDescriptor = new ComponentDescriptor(Component);
		
		descriptor.children = [a, b];
		b.children = [ba];
		
		var component:Component = descriptor.newInstance();
		Assert.assertEquals(2, component.children.length);
		Assert.assertEquals(0, a.children.length);
		Assert.assertEquals(1, b.children.length);
	}
}
}