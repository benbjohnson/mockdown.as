package mockdown.components.loaders
{
import mockdown.components.BaseComponent;
import org.mock4as.Mock;

public class MockComponentLoader extends Mock implements ComponentLoader
{
	public function find(name:String):* {
		record("find", name);
		return expectedReturnFor("find");
	}
	public function newInstance(name:String):BaseComponent {
		record("newInstance", name);
		return expectedReturnFor("newInstance") as BaseComponent;
	}
	public function addLibrary(name:String):void {
		record("addLibrary", name);
	}
}
}