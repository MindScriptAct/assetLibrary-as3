package integration.core {
import flash.system.ApplicationInstaller;
import flexunit.framework.Assert;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.AssetLibraryLoader;
import utils.AsyncUtil;

/**
 * COMMENT
 * @author
 */
public class CoreTests {
	
	[Before]
	
	public function runBeforeEveryTest():void {
	}
	
	[After]
	
	public function runAfterEveryTest():void {
	}
	
	//----------------------------------
	//     Vector of objects
	//----------------------------------
	
	[Test]
	
	public function core_getIndex_ok():void {
		var assetIndex:AssetLibraryIndex = AssetLibrary.getIndex();
		Assert.assertNotNull("assetIndex must be not null", assetIndex);
	}
	[Test]
	
	public function core_getIndexTwice_equals():void {
		var assetIndex:AssetLibraryIndex = AssetLibrary.getIndex();
		var assetIndex2:AssetLibraryIndex = AssetLibrary.getIndex();
		Assert.assertEquals("assetIndex must be the same.", assetIndex, assetIndex2);
	}
	
	[Test]
	
	public function core_getLoader_ok():void {
		var assetLoader:AssetLibraryLoader = AssetLibrary.getLoader();
		Assert.assertNotNull("assetIndex must be not null", assetLoader);
	}
	[Test]
	
	public function core_getLoaderTwice_equals():void {
		var assetLoader:AssetLibraryLoader = AssetLibrary.getLoader();
		var assetLoader2:AssetLibraryLoader = AssetLibrary.getLoader();
		Assert.assertEquals("assetIndex must be the same.", assetLoader, assetLoader2);
	}

}
}