package storadgeTest {
import com.bit101.components.PushButton;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.System;
import flash.utils.getTimer;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.AssetLibraryLoader;
import mindscriptact.assetLibrary.assets.PICAsset;
import mindscriptact.assetLibrary.assets.SWFAsset;
import utils.debug.Stats;

/**
 * Application initial point. PureMVC starter.
 * @author Raimundas Banevicius
 */
public class MainStoradgeTest extends Sprite {
	private var assetIndex:AssetLibraryIndex;
	private var assetLoader:AssetLibraryLoader;
	private var startInitialLoad:int;
	private var allBitmaps:Vector.<Bitmap> = new Vector.<Bitmap>();
	private var mLoader:Loader;
	
	static public const BIG20MB:String = "big20mb";
	static public const ANIM_MC:String = "animTick";
	static public const TEST_PIC:String = "test";
	
	public function MainStoradgeTest():void {
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		//DebugMan.info("Start");
		
		this.addChild(new Stats(120, 0, 0, false, true, true));
		
		assetIndex = AssetLibrary.getIndex();
		
		assetLoader = AssetLibrary.getLoader();
		
		assetIndex.addFileDefinition(BIG20MB, "assets/bigLibs/big20MB.swf");
		assetIndex.addFileDefinition(ANIM_MC, "assets/bigLibs/animTick.swf");
		assetIndex.addFileDefinition(TEST_PIC, "assets/bigLibs/test.png");
		
		new PushButton(this, 50, 150, "Show SO settings", handleShowSoSettings);
		new PushButton(this, 150, 150, "Enable SO use", handleEnableSOUse);
		new PushButton(this, 250, 150, "Force GC", handleForceGC);
		
		new PushButton(this, 50, 200, "Load&Add pics", handleStartLoad);
		new PushButton(this, 150, 200, "Remove pics", handleRemovePics);
		new PushButton(this, 250, 200, "Unload asset", handleUnload);
		
		new PushButton(this, 400, 200, "Load animation", handleAnimLoad);
		new PushButton(this, 500, 200, "Unload animation", handleAnimUnload);
		
		new PushButton(this, 650, 200, "Load pic", handlePicLoad);
		new PushButton(this, 750, 200, "Unload pic", handlePicUnload);
		
		new PushButton(this, 50, 250, "1MB StandartLoad", handleNormalLoad1MB);
		new PushButton(this, 150, 250, "20MB StandartLoad", handleNormalLoad20MB);
		new PushButton(this, 250, 250, "AnimTest", handleNormalAnimLoad);
	
	}
	
	//----------------------------------
	//     pic
	//----------------------------------
	
	private function handlePicLoad(event:Event):void {
		AssetLibrary.loadAsset(TEST_PIC, handleDoNothingWithPic);
	}
	
	private function handleDoNothingWithPic(asset:PICAsset):void {
	}
	
	private function handlePicUnload(event:Event):void {
		AssetLibrary.unloadAsset(TEST_PIC);
	}
	
	//----------------------------------
	//     anim
	//----------------------------------
	
	private function handleAnimUnload(event:Event):void {
		AssetLibrary.unloadAsset(ANIM_MC);
	}
	
	private function handleAnimLoad(event:Event):void {
		AssetLibrary.loadAsset(ANIM_MC, handleDoNothingWithSwf);
	}
	
	private function handleDoNothingWithSwf(asset:SWFAsset):void {
	}
	
	//----------------------------------
	//     
	//----------------------------------
	
	private function handleNormalLoad1MB(event:Event):void {
		mLoader = new Loader();
		var mRequest:URLRequest = new URLRequest("assets/bigLibs/big1MB.swf");
		mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
		//mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
		mLoader.load(mRequest);
	}
	
	private function handleNormalLoad20MB(event:Event):void {
		mLoader = new Loader();
		var mRequest:URLRequest = new URLRequest("assets/bigLibs/big20MB.swf");
		mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
		//mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
		mLoader.load(mRequest);
	}
	
	private function handleNormalAnimLoad(event:Event):void {
		mLoader = new Loader();
		var mRequest:URLRequest = new URLRequest("assets/bigLibs/animTick.swf");
		mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
		//mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
		mLoader.load(mRequest);
	}
	
	private function onCompleteHandler(event:Event):void {
		//var content:DisplayObject = event.currentTarget.content as DisplayObject;
		//addChild(content);
		//content.y = 300;
		
		//mLoader.unload();
		mLoader.unloadAndStop(false);
		mLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
		mLoader = null;
	}
	
	private function handleForceGC(event:Event):void {
		System.gc()
	}
	
	private function handleUnload(event:Event):void {
		AssetLibrary.unloadAsset(BIG20MB);
	}
	
	private function handleRemovePics(event:Event):void {
		while (allBitmaps.length) {
			var pic:Bitmap = allBitmaps.pop();
			this.removeChild(pic);
		}
	}
	
	private function handleEnableSOUse(event:Event):void {
		AssetLibrary.localStoradgeEnabled = true;
	}
	
	private function handleShowSoSettings(event:Event):void {
		AssetLibrary.forseOpenLocalStorageSettings();
	}
	
	private function handleStartLoad(event:Event):void {
		trace("MainStoradgeTest.handleStartLoad > event : " + event);
		
		startInitialLoad = getTimer();
		
		AssetLibrary.loadAsset(BIG20MB, handleSwfLoaded);
	}
	
	private function handleSwfLoaded(asset:SWFAsset):void {
		
		trace("Loaded in " + (getTimer() - startInitialLoad));
		startInitialLoad = getTimer();
		
		for (var i:int = 1; i < 7; i++) {
			var testBd:Bitmap = asset.getBitmapFromBitmapData("Pic" + i + "_BD");
			this.addChild(testBd);
			testBd.scaleX = 0.1;
			testBd.scaleY = 0.1;
			testBd.x = 200 + i * 20;
			testBd.y = 200 + i * 20;
			
			allBitmaps.push(testBd);
		}
		
		trace("Created and added in " + (getTimer() - startInitialLoad));
	
	}

}
}