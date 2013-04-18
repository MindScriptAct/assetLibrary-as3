/**
 * Created with IntelliJ IDEA.
 * User: rbanevicius
 * Date: 4/17/13
 * Time: 6:46 PM
 * To change this template use File | Settings | File Templates.
 */
package integration.assetVersioning {
import constants.AssetConstants;
import constants.AssetId;
import constants.AssetUrl;

import flexunit.framework.Assert;

import integration.assetDefine.AssetDefineTests;

import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.core.AssetDefinition;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;

public class AssetVersioningTests {

	static private var assetIndex:AssetLibraryIndex = AssetLibrary.getIndex();

	[Before]

	public function runBeforeEveryTest():void {
	}

	[After]

	public function runAfterEveryTest():void {
		assetIndex.removeAll();
	}


	[Test]

	public function assetVersioning_simleVersionedFile_cvTagOk():void {

		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.JPG_TEST, null, false, AssetConstants.CV_TAG_TEST);

		use namespace assetlibrary;
		var assetDefinition:AssetDefinition = assetIndex.getAssetDefinition(AssetId.ASSET1);

		Assert.assertEquals("Asset must have path with params.", assetDefinition.filePath, AssetUrl.JPG_TEST+AssetConstants.CV_TAG_TEST);


	}

	[Test]

	public function assetVersioning_defineFileThenAddCvTag_cvTagOk():void {
		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.JPG_TEST);
		assetIndex.addUrlParams(AssetUrl.JPG_TEST, AssetConstants.CV_TAG_TEST);

		use namespace assetlibrary;
		var assetDefinition:AssetDefinition = assetIndex.getAssetDefinition(AssetId.ASSET1);

		Assert.assertEquals("Asset should be able to get sv tags after they are defined.", assetDefinition.filePath, AssetUrl.JPG_TEST+AssetConstants.CV_TAG_TEST);

	}

	[Test]

	public function assetVersioning_addCvTagThenDefineFile_cvTagOk():void {

		assetIndex.addUrlParams(AssetUrl.JPG_TEST, AssetConstants.CV_TAG_TEST);

		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.JPG_TEST);

		use namespace assetlibrary;
		var assetDefinition:AssetDefinition = assetIndex.getAssetDefinition(AssetId.ASSET1);

		Assert.assertEquals("Asset should be able to get sv tags before they are defined.", assetDefinition.filePath, AssetUrl.JPG_TEST+AssetConstants.CV_TAG_TEST);

	}

}
}
