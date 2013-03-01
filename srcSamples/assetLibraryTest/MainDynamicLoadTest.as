package assetLibraryTest {
import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.AssetLibraryLoader;
import mindscriptact.assetLibrary.assets.PICAsset;
import mindscriptact.assetLibrary.assets.SWFAsset;
import mindscriptact.assetLibrary.core.AssetType;
import mindscriptact.assetLibrary.events.AssetEvent;
import mindscriptact.assetLibrary.events.AssetLoaderEvent;
import mindscriptact.logmaster.DebugMan;

/**
 * Application initial point. PureMVC starter.
 * @author Raimundas Banevicius
 */
public class MainDynamicLoadTest extends Sprite {
	private var assetIndex:AssetLibraryIndex;
	private var assetLoader:AssetLibraryLoader;
	
	public function MainDynamicLoadTest():void {
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
		
		//var asset:AssetSWF = new AssetSWF();		
		//assetIndex.addAsset(asset);
		
		//
		assetLoader.addEventListener(AssetLoaderEvent.XML_LOADING_STARTED, handleXMLLoadStartted);
		assetLoader.addEventListener(AssetLoaderEvent.XML_LOADED, handleXMLLoadFinished);
		//
		assetLoader.addEventListener(AssetEvent.ASSET_LOADING_STARTED, handleLoadStarted);
		assetLoader.addEventListener(AssetEvent.ASSET_LOADED, handleLoadFinished);
		//
		assetLoader.addEventListener(AssetEvent.PROGRESS, handleLoadingProgress);
		
		assetLoader.addEventListener(AssetLoaderEvent.ALL_PERMANENTS_LOADED, handleAllLoadFinished);
		
		
		//----------------------------------
		//     
		//----------------------------------
		
		assetIndex.addPathDefinition("simpleTest", "assets/simpleTest/", AssetType.SWF);
		
		AssetLibrary.loadDynamicAsset("simpleTest", "test1", handleTest1);
		AssetLibrary.loadDynamicAsset("simpleTest", "test1", handleTest1);
		AssetLibrary.loadDynamicAsset("simpleTest", "test2", handleTest2);
		
		
	
	}
	
	private function handleLoadingProgress(event:AssetEvent):void {
		DebugMan.info("#>>>MainDynamicLoadTest.handleLoadingProgress > event : " + event);
	}
	
	private function handleXMLLoadStartted(event:AssetLoaderEvent):void {
		DebugMan.info("MainDynamicLoadTest.handleXMLLoadStartted > event : " + event);
	}
	
	private function handleXMLLoadFinished(event:AssetLoaderEvent):void {
		DebugMan.info("MainDynamicLoadTest.handleXMLLoadFinished > event : " + event);
	}
	
//	private function handleXmlsLoadedFinished(event:AssetEvent):void {
//		DebugMan.info("Main.handleXmlsLoadedFinished > event : " + event);
//	}
	
	private function handleLoadStarted(event:AssetEvent):void {
		//DebugMan.info("Main.handleLoadStarted > event : " + event);
	}
	
	private function handleLoadFinished(event:AssetEvent):void {
		//DebugMan.info("Main.handleLoadFinished > event : " + event);
	}
	
	private function handleAllLoadFinished(event:AssetLoaderEvent):void {
	}
	
	private function handleTest1(asset:SWFAsset):void {
		////DebugMan.info("Main.handleTest1 > asset : " + asset);
		
		var anim:MovieClip = asset.getMovieClip("AnimMC");
		this.addChild(anim);
		anim.x = 100;
		anim.y = 300;
		
		var testSprite:Sprite = asset.getSprite("SquareA_SPR");
		this.addChild(testSprite);
		testSprite.x = 100;
		testSprite.y = 100;
	}
	
	private function handleTest2(asset:SWFAsset):void {
		trace("MainDynamicLoadTest.handleTest2 > asset : " + asset);
		////DebugMan.info("Main.handleTest3 > asset : " + asset);
		//var testSprite:Sprite = asset.getSprite("SquareB_SPR");
		//this.addChild(testSprite);
		//testSprite.x = 300;
		//testSprite.y = 100;
	}

}
}