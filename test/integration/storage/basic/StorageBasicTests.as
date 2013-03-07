package integration.storage.basic {
import flexunit.framework.Assert;
import utils.AsyncUtil;

/**
 * COMMENT
 * @author
 */
public class StorageBasicTests {

	
	[Before]
	public function runBeforeEveryTest():void {
	}
	
	[After]
	public function runAfterEveryTest():void {
	}
	
	//----------------------------------
	//     Vector of objects
	//----------------------------------
	
	
	
	private var asincFunction:Function;
	
	[Test(async)]
	
	public function versioning_empty_ok():void {
		
		asincFunction = AsyncUtil.asyncHandler(this, callBack, ["Send to call back."], 2000, failFunciton);
		
		asincFunction("Call back!");
	
	}
	
	private function callBack(callBackParam:String, aditionalParam:String):void {
		trace( "StorageBasicTests.callBack > callBackParam : " + callBackParam + ", aditionalParam : " + aditionalParam );
	}
	
	private function failFunciton(params:int):void {
		trace("StorageBasicTests.failFunciton");
		Assert.fail();
	}


}
}