package mockdown.test
{
	import asunit.errors.AssertionFailedError;
	import flash.utils.getQualifiedClassName;
	
	public function assertThrowsWithMessage(errorType:Class, message:String, block:Function):void
	{
		try {
			block.call();
		}
		catch(e:Error) {
			if(!(e is errorType)) {
				throw new AssertionFailedError("expected error type:<" + getQualifiedClassName(errorType)
					+"> but was:<" + getQualifiedClassName(e) + ">");
			}
			else if(message != e.message) {
				throw new AssertionFailedError("expected error message:<" + message +"> but was:<" + e.message + ">");
			}
			return;
		}
		throw new AssertionFailedError("expected error type:<" + getQualifiedClassName(errorType) + "> but none was thrown." );
	}
}
