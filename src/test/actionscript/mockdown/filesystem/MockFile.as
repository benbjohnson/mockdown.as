package mockdown.filesystem
{
import org.mock4as.Mock;

[Bindable]                                                                          
public class MockFile extends Mock implements File
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	public function MockFile(name:String=null, content:String=null)
	{
		this.name = name;
		this.content = content;
	}

	//--------------------------------------------------------------------------
	//
	//	Properties
	//
	//--------------------------------------------------------------------------
	 
	public var name:String;
	public var path:String;
	public var files:Array;
	public var isDirectory:Boolean;
	public var parent:File;
	public var root:File;
	public var content:String;


	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	public function resolvePath(path:String):File
	{
		record("resolvePath", path);
		return expectedReturnFor("resolvePath") as File;
	}
}
}
