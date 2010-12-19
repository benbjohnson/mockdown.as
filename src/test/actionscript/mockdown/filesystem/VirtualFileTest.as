package mockdown.filesystem
{
import asunit.framework.Assert;

public class VirtualFileTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var file:VirtualFile;

	[Before]
	public function setup():void
	{
	}
	

	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function constructorShouldSetName():void
	{
		Assert.assertEquals("foo", (new VirtualFile("foo")).name);
	}

	[Test(expects="ArgumentError")]
	public function constructorShouldThrowErrorWhenNameContainsSlash():void
	{
		new VirtualFile("foo/bar");
	}
	
	[Test]
	public function constructorShouldSetContent():void
	{
		Assert.assertEquals("bar", (new VirtualFile(null, "bar")).content);
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldFindRoot():void
	{
		var f0:VirtualFile = new VirtualFile();
		var f1:VirtualFile = new VirtualFile("foo");
		var f2:VirtualFile = new VirtualFile("bar");
		f0.add(f1);
		f1.add(f2);
		Assert.assertEquals(f0, f2.root);
	}

	[Test]
	public function shouldDeterminePath():void
	{
		var f0:VirtualFile = new VirtualFile();
		var f1:VirtualFile = new VirtualFile("foo");
		var f2:VirtualFile = new VirtualFile("bar");
		f0.add(f1);
		f1.add(f2);
		Assert.assertEquals("/foo/bar", f2.path);
	}

	[Test]
	public function shouldBeADirectory():void
	{
		Assert.assertTrue((new VirtualFile("foo")).isDirectory);
	}

	[Test]
	public function shouldBeAFile():void
	{
		Assert.assertFalse((new VirtualFile("foo", "bar")).isDirectory);
	}

	
	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//---------------------------------
	//	File management
	//---------------------------------

	[Test]
	public function shouldResolveImmediatePath():void
	{
		var root:VirtualFile = new VirtualFile();
		var f0:VirtualFile   = new VirtualFile("foo", "abc");
		root.add(f0);
		Assert.assertEquals(f0, root.resolvePath("foo"));
	}

	[Test]
	public function shouldResolveNestedPath():void
	{
		var root:VirtualFile = new VirtualFile();
		var f0:VirtualFile   = new VirtualFile("foo");
		var f1:VirtualFile   = new VirtualFile("bar");
		var f2:VirtualFile   = new VirtualFile("baz", "abc");
		root.add(f0);
		f0.add(f1);
		f1.add(f2);
		Assert.assertEquals(f2, root.resolvePath("foo/bar/baz"));
	}

	[Test]
	public function shouldNotResolveNonExistantFile():void
	{
		var root:VirtualFile = new VirtualFile();
		var f0:VirtualFile   = new VirtualFile("foo");
		var f1:VirtualFile   = new VirtualFile("bar", "abc");
		root.add(f0);
		f0.add(f1);
		Assert.assertNull(root.resolvePath("foo/bat"));
	}

	[Test]
	public function shouldResolveNullPathToNull():void
	{
		Assert.assertNull((new VirtualFile()).resolvePath(null));
	}

	[Test]
	public function shouldResolveEmptyPathToNull():void
	{
		Assert.assertNull((new VirtualFile()).resolvePath(""));
	}

	[Test]
	public function shouldAddFile():void
	{
		var root:VirtualFile = new VirtualFile();
		var f0:VirtualFile   = new VirtualFile("foo", "abc");
		root.add(f0);
		Assert.assertEquals(1, root.files.length);
		Assert.assertEquals(f0, root.files[0]);
	}

	[Test]
	public function shouldOnlyAddAFileOnce():void
	{
		var root:VirtualFile = new VirtualFile();
		var f0:VirtualFile   = new VirtualFile("foo", "abc");
		root.add(f0);
		root.add(f0);
		Assert.assertEquals(f0, root.files[0]);
	}

	[Test]
	public function shouldSetParentWhenAddingFile():void
	{
		var root:VirtualFile = new VirtualFile();
		var f0:VirtualFile   = new VirtualFile("foo", "abc");
		root.add(f0);
		Assert.assertEquals(root, f0.parent);
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorWhenAddingANullFile():void
	{
		(new VirtualFile()).add(null);
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorWhenAddingAnUnnamedFile():void
	{
		(new VirtualFile()).add(new VirtualFile());
	}

	[Test]
	public function shouldRemoveFile():void
	{
		var root:VirtualFile = new VirtualFile();
		var f0:VirtualFile   = new VirtualFile("foo", "abc");
		root.add(f0);
		root.remove(f0);
		Assert.assertEquals(0, root.files.length);
	}

	[Test]
	public function shouldUnsetParentWhenRemovingFile():void
	{
		var root:VirtualFile = new VirtualFile();
		var f0:VirtualFile   = new VirtualFile("foo", "abc");
		root.add(f0);
		root.remove(f0);
		Assert.assertNull(f0.parent);
	}

	[Test]
	public function removeShouldIgnoreNullFiles():void
	{
		(new VirtualFile()).remove(null);
	}
}
}