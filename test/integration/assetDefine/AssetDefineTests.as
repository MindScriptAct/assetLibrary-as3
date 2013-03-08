package integration.assetDefine {
import constants.AssetId;
import constants.PathId;
import flexunit.framework.Assert;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;

/**
 * COMMENT
 * @author
 */
public class AssetDefineTests {
	
	static private var assetIndex:AssetLibraryIndex = AssetLibrary.getIndex();
	
	[Before]
	
	public function runBeforeEveryTest():void {
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		assetIndex.removeAll();
	}
	
	[AfterClass]
	
	static public function runAfterClass():void {
		assetIndex.removeAll();
		assetIndex = null;
	}
	
	//----------------------------------
	//     file definition
	//----------------------------------
	
	[Test]
	
	public function assetDefine_addSimpleFile_ok():void {
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf");
		Assert.assertTrue("Defined asset must be found.", assetIndex.isAssetDefined(AssetId.ASSET1));
	}
	
	[Test]
	
	public function assetDefine_addSameSimpleFileTwice_ok():void {
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf");
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf");
	}
	
	[Test(expects="Error")]
	
	public function assetDefine_addDiferentSimpleFileTwice_fails():void {
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf");
		assetIndex.addFileDefinition(AssetId.ASSET1, "test2.swf");
	}
	
	[Test]
	
	public function assetDefine_noAddSimpleFile_fails():void {
		Assert.assertFalse("Defined asset must be NOT found.", assetIndex.isAssetDefined(AssetId.ASSET1));
	}
	
	[Test]
	
	public function assetDefine_addAndRemoveSimpleFile_ok():void {
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf");
		assetIndex.removeAssetDefinition(AssetId.ASSET1);
		Assert.assertFalse("Defined and removed asset must be NOT found.", assetIndex.isAssetDefined(AssetId.ASSET1));
	}
	
	[Test]
	
	public function assetDefine_addAndRemoveAllSimpleFile_ok():void {
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf");
		assetIndex.removeAll();
		Assert.assertFalse("Defined and removed all asset must be NOT found.", assetIndex.isAssetDefined(AssetId.ASSET1));
	}
	
	//----------------------------------
	//     path definition
	//----------------------------------	
	
	[Test]
	
	public function assetDefine_addSamePathTwice_ok():void {
		assetIndex.addPathDefinition(PathId.PATH1, "test");
		assetIndex.addPathDefinition(PathId.PATH1, "test");
	}
	
	[Test(expects="Error")]
	
	public function assetDefine_addDiferentPathTwice_fails():void {
		assetIndex.addPathDefinition(PathId.PATH1, "test1");
		assetIndex.addPathDefinition(PathId.PATH1, "test2");
	}
	
	[Test(expects="Error")]
	
	public function assetDefine_addFileWithMissingPath_fails():void {
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf", PathId.PATH1);
	}
	
	[Test]
	
	public function assetDefine_addFileWithPath_ok():void {
		assetIndex.addPathDefinition(PathId.PATH1, "test");
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf", PathId.PATH1);
	}
	
	[Test(expects="Error")]
	
	public function assetDefine_addFileWithMissingPathAfterItIsRemoved_fails():void {
		assetIndex.addPathDefinition(PathId.PATH1, "test");
		assetIndex.removePathDefinition(PathId.PATH1);
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf", PathId.PATH1);
	}
	
	[Test(expects="Error")]
	
	public function assetDefine_addFileWithMissingPathAfterItIsRemovedAll_fails():void {
		assetIndex.addPathDefinition(PathId.PATH1, "test");
		assetIndex.removeAll();
		assetIndex.addFileDefinition(AssetId.ASSET1, "test1.swf", PathId.PATH1);
	}
}
}