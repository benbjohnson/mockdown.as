package mockdown
{
import mockdown.data.DataSuite;
import mockdown.parsers.ParsersSuite;
import mockdown.managers.ManagersSuite;
import mockdown.utils.UtilsSuite;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class MockdownSuite
{
	public var s0:DataSuite;
	public var s1:ParsersSuite;
	public var s2:ManagersSuite;
	public var s3:UtilsSuite;
}
}