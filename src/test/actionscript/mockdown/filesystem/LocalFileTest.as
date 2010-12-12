package mockdown.filesystem
{
import flash.filesystem.File;

import asunit.framework.Assert;

import mockdown.utils.FileUtil;

public class LocalFileTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------

	private var testDirectory:flash.filesystem.File = flash.filesystem.File.applicationStorageDirectory.resolvePath("test");
	private var root:LocalFile;
	private var foo:LocalFile;
	private var bar:LocalFile;
	private var baz:LocalFile;

	[Before]
	public function setup():void
	{
		testDirectory.createDirectory();
		testDirectory.resolvePath("foo").createDirectory();
		testDirectory.resolvePath("foo/bar").createDirectory();
		FileUtil.write(testDirectory.resolvePath("foo/bar/baz"), "abc");

		root = new LocalFile(testDirectory);
		foo = root.resolvePath("foo") as LocalFile;
		bar = foo.resolvePath("bar") as LocalFile;
		baz = bar.resolvePath("baz") as LocalFile;
	}

	[After]
	public function teardown():void
	{
		testDirectory.deleteDirectory(true);
	}
	

	//---------------------------------------------------------------------
	//
	//  Constructor
	//
	//---------------------------------------------------------------------
	
	[Test]
	public function constructorShouldAllowFileReference():void
	{
		Assert.assertEquals(testDirectory, (new LocalFile(testDirectory)).nativeFile);
	}

	[Test]
	public function constructorShouldAllowPath():void
	{
		Assert.assertEquals(testDirectory.nativePath, (new LocalFile(testDirectory.nativePath)).nativePath);
	}

	[Test(expects="ArgumentError")]
	public function constructorShouldThrowErrorWhenFileIsNull():void
	{
		new LocalFile(null);
	}
	
	[Test(expects="ArgumentError")]
	public function constructorShouldThrowErrorWhenFileIsNotARefOrPath():void
	{
		new LocalFile({});
	}
	
	
	//---------------------------------------------------------------------
	//
	//  Properties
	//
	//---------------------------------------------------------------------

	[Test]
	public function shouldFindRoot():void
	{
		Assert.assertEquals(root, baz.root);
	}

	[Test]
	public function shouldDeterminePath():void
	{
		Assert.assertEquals("/foo/bar/baz", baz.path);
	}

	[Test]
	public function shouldBeADirectory():void
	{
		Assert.assertTrue(foo.isDirectory);
	}

	[Test]
	public function shouldBeAFile():void
	{
		Assert.assertFalse(baz.isDirectory);
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
		Assert.assertEquals(foo.nativePath, (root.resolvePath("foo") as LocalFile).nativePath);
	}

	[Test]
	public function shouldResolveNestedPath():void
	{
		Assert.assertEquals(baz.nativePath, (root.resolvePath("foo/bar/baz") as LocalFile).nativePath);
		Assert.assertEquals("/foo/bar/baz", root.resolvePath("foo/bar/baz").path);
	}

	[Test]
	public function shouldNotResolveNonExistantFile():void
	{
		Assert.assertNull(root.resolvePath("foo/bat"));
	}

	[Test]
	public function shouldResolveNullPathToNull():void
	{
		Assert.assertNull(root.resolvePath(null));
	}

	[Test]
	public function shouldResolveEmptyPathToNull():void
	{
		Assert.assertNull(root.resolvePath(""));
	}
}
}