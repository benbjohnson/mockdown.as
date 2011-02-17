package mockdown.components.loaders
{
import mockdown.components.BaseComponent;
import mockdown.components.ComponentDescriptor;
import mockdown.components.parsers.MockComponentParser;
import mockdown.filesystem.MockFile;

import asunit.framework.Assert;

import flash.errors.IllegalOperationError;

public class FileComponentLoaderTest
{
	//---------------------------------------------------------------------
	//
	//  Setup
	//
	//---------------------------------------------------------------------
	
	private var loader:FileComponentLoader;

	private var parent:MockComponentLoader;
	private var child:FileComponentLoader;

	private var parser:MockComponentParser;
	private var descriptor:ComponentDescriptor;
	private var file:MockFile;
	
	[Before]
	public function setup():void
	{
		descriptor = new ComponentDescriptor();
		parser = new MockComponentParser();
		file = new MockFile();

		loader = new FileComponentLoader();
		loader.parser = parser;
		
		parent = new MockComponentLoader();
		child  = new FileComponentLoader(parent);
		child.parser = parser;
	}


	//---------------------------------------------------------------------
	//
	//  Methods
	//
	//---------------------------------------------------------------------
	
	//-----------------------------
	//  Find
	//-----------------------------

	[Test]
	public function shouldFindInParentLoader():void
	{
		parent.expects("find").withArgs("foo").willReturn(TestComponent);
		Assert.assertEquals(TestComponent, child.find("foo"));
	}

	[Test]
	public function shouldFindInPath():void
	{
		file.expects("resolvePath").withArgs("foo").willReturn(new MockFile("foo", "%bar"));
		parser.expects("parse").withArgs("%bar").willReturn(descriptor);
		loader.paths = [file];
		var ret:* = loader.find("foo");

		Assert.assertTrue(file.errorMessage(), file.success());
		Assert.assertTrue(parser.errorMessage(), parser.success());
		Assert.assertEquals(descriptor, ret);
	}

	[Test]
	public function shouldSearchAllPaths():void
	{
		file.expects("resolvePath").withArgs("foo").willReturn(null);
		file.expects("resolvePath").withArgs("foo.mkd").willReturn(null);
		file.expects("resolvePath").withArgs("foo.mkx").willReturn(null);
		var file2:MockFile = new MockFile();
		file2.expects("resolvePath").withArgs("foo").willReturn(new MockFile("foo", "%bar"));
		parser.expects("parse").withArgs("%bar").willReturn(descriptor);
		loader.paths = [file, file2];
		loader.find("foo");

		Assert.assertTrue(file.errorMessage(), file.success());
		Assert.assertTrue(parser.errorMessage(), parser.success());
	}

	[Test]
	public function shouldFindWithExtension():void
	{
		file.expects("resolvePath").withArgs("foo.mkd").willReturn(new MockFile("foo.mkd", "%bar"));
		parser.expects("parse").withArgs("%bar").willReturn(descriptor);
		loader.paths = [file];
		loader.find("foo.mkd");

		Assert.assertTrue(file.errorMessage(), file.success());
		Assert.assertTrue(parser.errorMessage(), parser.success());
	}

	[Test]
	public function shouldFindInLibraryPath():void
	{
		file.expects("resolvePath").withArgs("foo").willReturn(new MockFile("foo", "%bar"));
		parser.expects("parse").withArgs("%bar").willReturn(descriptor);
		loader.libraryPath = file;
		loader.find("foo");

		Assert.assertTrue(file.errorMessage(), file.success());
		Assert.assertTrue(parser.errorMessage(), parser.success());
	}

	[Test(expects="flash.errors.IllegalOperationError", message="File is a directory: foo")]
	public function shouldThrowErrorIfPathResolvesToDirectory():void
	{
		var file2:MockFile = new MockFile("foo");
		file2.isDirectory = true;
		file.expects("resolvePath").withArgs("foo").willReturn(file2);
		loader.paths = [file];
		loader.find("foo");

		Assert.assertTrue(file.errorMessage(), file.success());
		Assert.assertTrue(parser.errorMessage(), parser.success());
	}


	//-----------------------------
	//  Library
	//-----------------------------
	
	[Test]
	public function shouldAppendLibraryToPath():void
	{
		var libraryPath:MockFile = new MockFile();
		file.expects("resolvePath").withArgs("foo").willReturn(libraryPath);
		loader.systemLibraryPath = file;
		loader.addLibrary("foo");
		Assert.assertEquals(libraryPath, loader.paths[loader.paths.length-1]);
	}
	
	[Test(expects="ArgumentError", message="Library name is required")]
	public function shouldThrowErrorWhenAddingLibraryWithNoName():void
	{
		loader.addLibrary(null);
	}

	[Test(expects="flash.errors.IllegalOperationError", message="System library path has not been defined for this loader")]
	public function shouldThrowErrorWhenSystemLibraryPathIsUndefined():void
	{
		loader.addLibrary("foo");
	}
	
	[Test(expects="flash.errors.IllegalOperationError", message="Library name cannot contain: '..'")]
	public function shouldThrowErrorLibraryNameContainsDoubleDot():void
	{
		loader.systemLibraryPath = file;
		loader.addLibrary("../foo");
	}
	
	[Test(expects="mockdown.errors.LibraryNotFoundError", message="Library not found: foo")]
	public function shouldThrowErrorWhenLibraryNotFound():void
	{
		file.expects("resolvePath").withArgs("foo").willReturn(null);
		loader.systemLibraryPath = file;
		loader.addLibrary("foo");
	}


	//-----------------------------
	//  Clone
	//-----------------------------
	
	[Test]
	public function shouldCloneIntoNewLoader():void
	{
		Assert.assertTrue(loader != loader.clone());
	}
	
	[Test]
	public function shouldCloneParent():void
	{
		var clone:FileComponentLoader = loader.clone();
		Assert.assertEquals(loader.parent, clone.parent);
	}
	
	[Test]
	public function shouldCloneLibraryPath():void
	{
		var clone:FileComponentLoader = loader.clone();
		Assert.assertEquals(loader.libraryPath, clone.libraryPath);
	}
	
	[Test]
	public function shouldCloneSystemLibraryPath():void
	{
		var clone:FileComponentLoader = loader.clone();
		Assert.assertEquals(loader.systemLibraryPath, clone.systemLibraryPath);
	}
}
}

import mockdown.components.BaseComponent;
class TestComponent extends BaseComponent{}
