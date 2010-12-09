package
{
import mockdown.MockdownSuite;
import asunit.core.TextCore;
import flash.display.Sprite;

[SWF(backgroundColor='#333333')]
public class TestRunner extends Sprite
{
	//--------------------------------------------------------------------------
	//
	//	Constructor
	//
	//--------------------------------------------------------------------------

	public function TestRunner()
	{
		var core:TextCore = new TextCore();
		core.textPrinter.hideLocalPaths = true;
		core.textPrinter.traceOnComplete = false;
		core.start(MockdownSuite, null, this);
	}
}
}
