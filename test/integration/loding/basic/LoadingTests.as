package integration.loding.basic {
import constants.AssetId;
import constants.AssetUrl;
import flash.display.MovieClip;
import flash.text.TextField;
import flexunit.framework.Assert;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.assets.SwfAsset;
import mindscriptact.assetLibrary.core.loader.AssetLoader;
import utils.AsyncUtil;

/**
 * COMMENT
 * @author
 */
public class LoadingTests {
	
	static private var assetIndex:AssetLibraryIndex = AssetLibrary.getIndex();
	
	
	[Before]
	
	public function runBeforeEveryTest():void {
		assetIndex.removeAll();
	}
	
	[After]
	
	public function runAfterEveryTest():void {
	}
	
	[AfterClass]
	
	static public function runAfterClass():void {
		assetIndex.removeAll();
		assetIndex = null;
	}
	
	//----------------------------------
	//     Vector of objects
	//----------------------------------
	
	private var simpleLoad_asincFunction:Function;
	
	[Test(async)]
	
	public function loading_simpleLoad_ok():void {
		
		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.URL1);
		
		AssetLibrary.loadAsset(AssetId.ASSET1, handleSimpleLoadAsset);
		
		simpleLoad_asincFunction = AsyncUtil.asyncHandler(this, simpleLoad_callBack, null, 1000, simpleLoad_fail);
	
	}
	
	private function handleSimpleLoadAsset(asset:SwfAsset):void {
		trace("LoadingTests.handleSimpleLoadAsset > asset : " + asset);
		simpleLoad_asincFunction(asset.getMovieClip("test1MC"));
	}
	
	private function simpleLoad_callBack(testMC:MovieClip):void {
		if (testMC) {
			var testField:TextField = testMC.testField
			if (testField) {
				Assert.assertEquals("Loaded data does not match.", "test1.swf-test1MC", testField.text);
			} else {
				Assert.fail("Failed to get test textField.");
			}
		} else {
			Assert.fail("Failed to get linked object.");
		}
	
	}
	
	private function simpleLoad_fail(param:Object = null):void {
		Assert.fail("simpleLoad failed.");
	}

}
}