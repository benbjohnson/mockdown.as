package mockdown.managers
{
import org.flexunit.Assert;

public class NodeManagerTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var manager:NodeManager;
	
	[Before]
	public function setup():void
	{
		manager = new NodeManager();
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function shouldRegisterType():void
	{
		manager.register("foo", TestClass);
		Assert.assertEquals(TestClass, manager.find("foo"));
	}

	[Test]
	public function shouldUnregisterType():void
	{
		manager.register("foo", TestClass);
		manager.unregister("foo");
		Assert.assertNull(manager.find("foo"));
	}

	[Test]
	public function shouldCreateRegisteredClass():void
	{
		manager.register("foo", TestClass);
		Assert.assertTrue(manager.create("foo") is TestClass);
	}
}
}


import mockdown.components.Node;

class TestClass extends Node
{
}