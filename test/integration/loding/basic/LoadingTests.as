package integration.loding.basic {
import constants.AssetId;
import constants.AssetUrl;
import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.media.Sound;
import flash.text.TextField;
import flexunit.framework.Assert;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.assets.PicAsset;
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
	//     swf load test
	//----------------------------------
	
	private var simpleSwfMovieClipLoad_asincFunction:Function;
	
	[Test(async)]
	
	public function loading_simpleSwfMovieClipLoad_ok():void {
		
		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.SWF_TEST_1);
		
		AssetLibrary.loadAsset(AssetId.ASSET1, simpleSwfMovieClipLoad_handleSimpleLoadAsset);
		
		simpleSwfMovieClipLoad_asincFunction = AsyncUtil.asyncHandler(this, simpleSwfMovieClipLoad_callBack, null, 1000, simpleSwfMovieClipLoad_fail);
	
	}
	
	private function simpleSwfMovieClipLoad_handleSimpleLoadAsset(asset:SwfAsset):void {
		trace("LoadingTests.handleSimpleLoadAsset > asset : " + asset);
		simpleSwfMovieClipLoad_asincFunction(asset.getMovieClip("test1MC"));
	}
	
	private function simpleSwfMovieClipLoad_callBack(test:MovieClip):void {
		if (test) {
			var testField:TextField = test.testField
			if (testField) {
				Assert.assertEquals("Loaded data does not match.", "test1.swf-test1MC", testField.text);
			} else {
				Assert.fail("Failed to get test textField.");
			}
		} else {
			Assert.fail("Failed to get linked object.");
		}
	
	}
	
	private function simpleSwfMovieClipLoad_fail(param:Object = null):void {
		Assert.fail("simpleLoad failed.");
	}
	
	///
	private var simpleSwfSpriteLoad_asincFunction:Function;
	
	[Test(async)]
	
	public function loading_simpleSwfSpriteLoad_ok():void {
		
		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.SWF_TEST_1);
		
		AssetLibrary.loadAsset(AssetId.ASSET1, simpleSwfSpriteLoad_handleSimpleLoadAsset);
		
		simpleSwfSpriteLoad_asincFunction = AsyncUtil.asyncHandler(this, simpleSwfSpriteLoad_callBack, null, 1000, simpleSwfSpriteLoad_fail);
	
	}
	
	private function simpleSwfSpriteLoad_handleSimpleLoadAsset(asset:SwfAsset):void {
		trace("LoadingTests.handleSimpleLoadAsset > asset : " + asset);
		simpleSwfSpriteLoad_asincFunction(asset.getSprite("test1SPR"));
	}
	
	private function simpleSwfSpriteLoad_callBack(test:Sprite):void {
		if (test) {
			var testField:TextField = test["testField"];
			if (testField) {
				Assert.assertEquals("Loaded data does not match.", "test1.swf-test1SPR", testField.text);
			} else {
				Assert.fail("Failed to get test textField.");
			}
		} else {
			Assert.fail("Failed to get linked object.");
		}
	
	}
	
	private function simpleSwfSpriteLoad_fail(param:Object = null):void {
		Assert.fail("simpleLoad failed.");
	}
	
	///
	private var simpleSwfSimpleButtonLoad_asincFunction:Function;
	
	[Test(async)]
	
	public function loading_simpleSwfSimpleButtonLoad_ok():void {
		
		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.SWF_TEST_1);
		
		AssetLibrary.loadAsset(AssetId.ASSET1, simpleSwfSimpleButtonLoad_handleSimpleLoadAsset);
		
		simpleSwfSimpleButtonLoad_asincFunction = AsyncUtil.asyncHandler(this, simpleSwfSimpleButtonLoad_callBack, null, 1000, simpleSwfSimpleButtonLoad_fail);

	}
	
	private function simpleSwfSimpleButtonLoad_handleSimpleLoadAsset(asset:SwfAsset):void {
		trace("LoadingTests.handleSimpleLoadAsset > asset : " + asset);
		simpleSwfSimpleButtonLoad_asincFunction(asset.getSimpleButton("test1BTN"));
	}
	
	private function simpleSwfSimpleButtonLoad_callBack(test:SimpleButton):void {
		Assert.assertNotNull("Failed to get linked button.", test);
	}
	
	private function simpleSwfSimpleButtonLoad_fail(param:Object = null):void {
		Assert.fail("simpleLoad failed.");
	}
	
	///
	private var simpleSwfSoundLoad_asincFunction:Function;
	
	[Test(async)]
	
	public function loading_simpleSwfSoundLoad_ok():void {
		
		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.SWF_TEST_1);
		
		AssetLibrary.loadAsset(AssetId.ASSET1, simpleSwfSoundLoad_handleSimpleLoadAsset);
		
		simpleSwfSoundLoad_asincFunction = AsyncUtil.asyncHandler(this, simpleSwfSoundLoad_callBack, null, 1000, simpleSwfSoundLoad_fail);
	
	}
	
	private function simpleSwfSoundLoad_handleSimpleLoadAsset(asset:SwfAsset):void {
		trace("LoadingTests.handleSimpleLoadAsset > asset : " + asset);
		simpleSwfSoundLoad_asincFunction(asset.getSound("test1SND"));
	}
	
	private function simpleSwfSoundLoad_callBack(test:Sound):void {
		Assert.assertNotNull("Failed to get linked sound.", test);
	}
	
	private function simpleSwfSoundLoad_fail(param:Object = null):void {
		Assert.fail("simpleLoad failed.");
	}
	
	//----------------------------------
	//     picture load test
	//----------------------------------
	
	private var simpleGifLoad_asincFunction:Function;
	
	[Test(async)]
	
	public function loading_simpleGifLoad_ok():void {
		
		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.GIF_TEST);
		
		AssetLibrary.loadAsset(AssetId.ASSET1, simpleGifLoad_handleSimpleLoadAsset);
		
		simpleGifLoad_asincFunction = AsyncUtil.asyncHandler(this, simpleGifLoad_callBack, null, 1000, simpleGifLoad_fail);
	
	}
	
	private function simpleGifLoad_handleSimpleLoadAsset(asset:PicAsset):void {
		trace("LoadingTests.handleSimpleLoadAsset > asset : " + asset);
		simpleGifLoad_asincFunction(asset.getBitmap());
	}
	
	private function simpleGifLoad_callBack(test:Bitmap):void {
		if (test) {
			Assert.assertEquals("Loaded pic shold be 200 width.", 200, test.width);
		} else {
			Assert.fail("Failed to get pic object.");
		}
	
	}
	
	private function simpleGifLoad_fail(param:Object = null):void {
		Assert.fail("simpleLoad failed.");
	}
	
	//
	
	private var simplePngLoad_asincFunction:Function;
	
	[Test(async)]
	
	public function loading_simplePngLoad_ok():void {
		
		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.PNG_TEST);
		
		AssetLibrary.loadAsset(AssetId.ASSET1, simplePngLoad_handleSimpleLoadAsset);
		
		simplePngLoad_asincFunction = AsyncUtil.asyncHandler(this, simplePngLoad_callBack, null, 1000, simplePngLoad_fail);
	
	}
	
	private function simplePngLoad_handleSimpleLoadAsset(asset:PicAsset):void {
		trace("LoadingTests.handleSimpleLoadAsset > asset : " + asset);
		simplePngLoad_asincFunction(asset.getBitmap());
	}
	
	private function simplePngLoad_callBack(test:Bitmap):void {
		if (test) {
			Assert.assertEquals("Loaded pic shold be 200 width.", 200, test.width);
		} else {
			Assert.fail("Failed to get pic object.");
		}
	
	}
	
	private function simplePngLoad_fail(param:Object = null):void {
		Assert.fail("simpleLoad failed.");
	}
	
	//
	
	private var simpleJpgLoad_asincFunction:Function;
	
	[Test(async)]
	
	public function loading_simpleJpgLoad_ok():void {
		
		assetIndex.addFileDefinition(AssetId.ASSET1, AssetUrl.JPG_TEST);
		
		AssetLibrary.loadAsset(AssetId.ASSET1, simpleJpgLoad_handleSimpleLoadAsset);
		
		simpleJpgLoad_asincFunction = AsyncUtil.asyncHandler(this, simpleJpgLoad_callBack, null, 1000, simpleJpgLoad_fail);
	
	}
	
	private function simpleJpgLoad_handleSimpleLoadAsset(asset:PicAsset):void {
		trace("LoadingTests.handleSimpleLoadAsset > asset : " + asset);
		simpleJpgLoad_asincFunction(asset.getBitmap());
	}
	
	private function simpleJpgLoad_callBack(test:Bitmap):void {
		if (test) {
			Assert.assertEquals("Loaded pic shold be 200 width.", 200, test.width);
		} else {
			Assert.fail("Failed to get pic object.");
		}
	
	}
	
	private function simpleJpgLoad_fail(param:Object = null):void {
		Assert.fail("simpleLoad failed.");
	}

}
}