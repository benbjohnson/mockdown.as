package mockdown.components.loaders
{
import mockdown.components.Component;
import org.mock4as.Mock;

public class MockComponentLoader extends Mock implements ComponentLoader
{
	public function find(name:String):* {
		record("find", name);
		return expectedReturnFor("find");
	}
	public function newInstance(name:String):Component {
		record("newInstance", name);
		return expectedReturnFor("newInstance") as Component;
	}
	public function addLibrary(name:String):void {
		record("addLibrary", name);
	}
}
}