package mockdown.filesystem
{
import org.flexunit.Assert;

public class MemoryFileTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var file:MemoryFile;

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
		Assert.assertEquals("foo", (new MemoryFile("foo")).name);
	}

	[Test(expects="ArgumentError")]
	public function constructorShouldThrowErrorWhenNameContainsSlash():void
	{
		new MemoryFile("foo/bar");
	}
	
	[Test]
	public function constructorShouldSetContent():void
	{
		Assert.assertEquals("bar", (new MemoryFile(null, "bar")).content);
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldFindRoot():void
	{
		var f0:MemoryFile = new MemoryFile();
		var f1:MemoryFile = new MemoryFile("foo");
		var f2:MemoryFile = new MemoryFile("bar");
		f0.add(f1);
		f1.add(f2);
		Assert.assertEquals(f0, f2.root);
	}

	[Test]
	public function shouldDeterminePath():void
	{
		var f0:MemoryFile = new MemoryFile();
		var f1:MemoryFile = new MemoryFile("foo");
		var f2:MemoryFile = new MemoryFile("bar");
		f0.add(f1);
		f1.add(f2);
		Assert.assertEquals("/foo/bar", f2.path);
	}

	[Test]
	public function shouldBeADirectory():void
	{
		Assert.assertTrue((new MemoryFile("foo")).isDirectory);
	}

	[Test]
	public function shouldBeAFile():void
	{
		Assert.assertFalse((new MemoryFile("foo", "bar")).isDirectory);
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
		var root:MemoryFile = new MemoryFile();
		var f0:MemoryFile   = new MemoryFile("foo", "abc");
		root.add(f0);
		Assert.assertEquals(f0, root.resolvePath("foo"));
	}

	[Test]
	public function shouldResolveNestedPath():void
	{
		var root:MemoryFile = new MemoryFile();
		var f0:MemoryFile   = new MemoryFile("foo");
		var f1:MemoryFile   = new MemoryFile("bar");
		var f2:MemoryFile   = new MemoryFile("baz", "abc");
		root.add(f0);
		f0.add(f1);
		f1.add(f2);
		Assert.assertEquals(f2, root.resolvePath("foo/bar/baz"));
	}

	[Test]
	public function shouldNotResolveNonExistantFile():void
	{
		var root:MemoryFile = new MemoryFile();
		var f0:MemoryFile   = new MemoryFile("foo");
		var f1:MemoryFile   = new MemoryFile("bar", "abc");
		root.add(f0);
		f0.add(f1);
		Assert.assertNull(root.resolvePath("foo/bat"));
	}

	[Test]
	public function shouldResolveNullPathToNull():void
	{
		Assert.assertNull((new MemoryFile()).resolvePath(null));
	}

	[Test]
	public function shouldResolveEmptyPathToNull():void
	{
		Assert.assertNull((new MemoryFile()).resolvePath(""));
	}

	[Test]
	public function shouldAddFile():void
	{
		var root:MemoryFile = new MemoryFile();
		var f0:MemoryFile   = new MemoryFile("foo", "abc");
		root.add(f0);
		Assert.assertEquals(1, root.files.length);
		Assert.assertEquals(f0, root.files[0]);
	}

	[Test]
	public function shouldOnlyAddAFileOnce():void
	{
		var root:MemoryFile = new MemoryFile();
		var f0:MemoryFile   = new MemoryFile("foo", "abc");
		root.add(f0);
		root.add(f0);
		Assert.assertEquals(f0, root.files[0]);
	}

	[Test]
	public function shouldSetParentWhenAddingFile():void
	{
		var root:MemoryFile = new MemoryFile();
		var f0:MemoryFile   = new MemoryFile("foo", "abc");
		root.add(f0);
		Assert.assertEquals(root, f0.parent);
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorWhenAddingANullFile():void
	{
		(new MemoryFile()).add(null);
	}

	[Test(expects="ArgumentError")]
	public function shouldThrowErrorWhenAddingAnUnnamedFile():void
	{
		(new MemoryFile()).add(new MemoryFile());
	}

	[Test]
	public function shouldRemoveFile():void
	{
		var root:MemoryFile = new MemoryFile();
		var f0:MemoryFile   = new MemoryFile("foo", "abc");
		root.add(f0);
		root.remove(f0);
		Assert.assertEquals(0, root.files.length);
	}

	[Test]
	public function shouldUnsetParentWhenRemovingFile():void
	{
		var root:MemoryFile = new MemoryFile();
		var f0:MemoryFile   = new MemoryFile("foo", "abc");
		root.add(f0);
		root.remove(f0);
		Assert.assertNull(f0.parent);
	}

	[Test]
	public function removeShouldIgnoreNullFiles():void
	{
		(new MemoryFile()).remove(null);
	}
}
}