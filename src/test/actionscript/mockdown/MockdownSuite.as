package mockdown
{
import mockdown.components.ComponentsSuite;
import mockdown.display.DisplaySuite;
import mockdown.filesystem.FileSystemSuite;
import mockdown.parsers.ParsersSuite;
import mockdown.managers.ManagersSuite;
import mockdown.utils.UtilsSuite;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class MockdownSuite
{
	public var s0:ComponentsSuite;
	public var s1:DisplaySuite;
	public var s2:FileSystemSuite;
	public var s3:ParsersSuite;
	public var s4:ManagersSuite;
	public var s5:UtilsSuite;
}
}