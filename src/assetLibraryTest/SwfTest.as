package assetLibraryTest {
import com.mindscriptact.assetLibrary.AssetLibrary;
import com.mindscriptact.assetLibrary.AssetLibraryIndex;
import com.mindscriptact.assetLibrary.AssetLibraryLoader;
import com.mindscriptact.assetLibrary.assets.MP3Asset;
import com.mindscriptact.assetLibrary.assets.PICAsset;
import com.mindscriptact.assetLibrary.assets.SWFAsset;
import com.mindscriptact.assetLibrary.event.AssetEvent;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.media.Sound;

/**
 * @author Raimundas Banevicius
 */
public class SwfTest extends Sprite {
	private var assetIndex:AssetLibraryIndex;
	private var assetLoader:AssetLibraryLoader;
	private var stageContent:MovieClip;

	public function SwfTest():void {
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		//DebugMan.info("Start");

		assetIndex = AssetLibrary.getIndex();

		assetLoader = AssetLibrary.getLoader();
		assetLoader.addEventListener(AssetEvent.ALL_PERMANENTS_LOADED, handleAllLoadFinished);
		
		
		
		
		assetIndex.addFileDefinition("swfTest", "assets/simpleTest/SWFtest.swf", null, true);

		
		
		
		assetLoader.preloadPermanents();
	}


	private function handleAllLoadFinished(event:AssetEvent):void {
		
		stageContent = AssetLibrary.getSWFStageContent("swfTest"); 
		this.addChild(stageContent);
		
		var testClip:MovieClip = AssetLibrary.getSWFMovieClip("swfTest", "MovieTestMC");
		this.addChild(testClip);
		testClip.x = 200;
		testClip.y = 300;

		var testSprite:Sprite = AssetLibrary.getSWFSprite("swfTest", "SpriteTestSPR");
		this.addChild(testSprite);
		testSprite.x = 200;
		testSprite.y = 350;
		
		var testButton:SimpleButton = AssetLibrary.getSWFSimpleButton("swfTest", "ButtonTestBTN");
		this.addChild(testButton);
		testButton.x = 200;
		testButton.y = 500;
		
		var testBitmapData:BitmapData = AssetLibrary.getSWFBitmapData("swfTest", "PicTestBD");
		var testBitmap:Bitmap = new Bitmap(testBitmapData);
		
		this.addChild(testBitmap);
		testBitmap.x = 500;
		testBitmap.y = 200;
		
		var testSound:Sound = AssetLibrary.getSWFSound("swfTest", "SoundTestSND");
		testSound.play();
		
		// termporal load test.
		AssetLibrary.sendAssetToFunction("swfTest", handleAsset);
		
	}

	private function handleAsset(asset:SWFAsset):void {
		
		this.removeChild(stageContent); // Can't use stage content second time without removing already used one.
		
		stageContent = asset.getStageContent();
		this.addChild(stageContent);
		
		
		var testClip:MovieClip = asset.getMovieClip("MovieTestMC");
		this.addChild(testClip);
		testClip.x = 200+10;
		testClip.y = 300+10;

		var testSprite:Sprite = asset.getSprite("SpriteTestSPR");
		this.addChild(testSprite);
		testSprite.x = 200+10;
		testSprite.y = 350+10;
		
		var testButton:SimpleButton = asset.getSimpleButton("ButtonTestBTN");
		this.addChild(testButton);
		testButton.x = 200+50;
		testButton.y = 500+50;
		
		var testBitmapData:BitmapData = asset.getBitmapData("PicTestBD");
		var testBitmap:Bitmap = new Bitmap(testBitmapData);
		
		this.addChild(testBitmap);
		testBitmap.x = 500+50;
		testBitmap.y = 200+50;
		
		var testSound:Sound = asset.getSound("SoundTestSND");
		testSound.play();
	}

}
}