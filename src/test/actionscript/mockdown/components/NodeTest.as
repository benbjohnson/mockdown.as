package mockdown.components
{
import org.flexunit.Assert;

public class NodeTest
{
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Children
	//-----------------------------

	[Test]
	public function shouldAppendChild():void
	{
		var parent:Node = new Node();
		var child:Node  = new Node();
		parent.addChild(child);
		Assert.assertEquals(parent, child.parent);
		Assert.assertEquals(1, parent.children.length);
		Assert.assertEquals(child, parent.children[0]);
	}

	[Test]
	public function shouldRemoveChild():void
	{
		var parent:Node = new Node();
		var child:Node  = new Node();
		parent.addChild(child);
		parent.removeChild(child);
		Assert.assertNull(child.parent);
		Assert.assertEquals(0, parent.children.length);
	}
}
}