package mockdown.parsers
{
import asunit.framework.Assert;

public class BlockTest
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
		var parent:Block = new Block();
		var child:Block  = new Block();
		parent.addChild(child);
		Assert.assertEquals(parent, child.parent);
		Assert.assertEquals(1, parent.children.length);
		Assert.assertEquals(child, parent.children[0]);
	}

	[Test]
	public function shouldRemoveChild():void
	{
		var parent:Block = new Block();
		var child:Block  = new Block();
		parent.addChild(child);
		parent.removeChild(child);
		Assert.assertNull(child.parent);
		Assert.assertEquals(0, parent.children.length);
	}
}
}