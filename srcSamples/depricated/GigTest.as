package depricated {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.utils.getTimer;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.AssetLibraryLoader;
import mindscriptact.assetLibrary.assets.SwfAsset;
import mindscriptact.logmaster.DebugMan;

/**
 * Application initial point. PureMVC starter.
 * @author Raimundas Banevicius
 */
public class GigTest extends Sprite {
	private var assetIndex:AssetLibraryIndex;
	private var assetLoader:AssetLibraryLoader;

	
	private var timeShot:int;
	private var fpsCounter:FPSgraph;
	
	public function GigTest():void {
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(event:Event = null):void {
		
		fpsCounter = new FPSgraph(this);
		fpsCounter.scaleX = fpsCounter.scaleY = 4;
		
//		var testtt:Loader = new Loader();
		
		AssetLibrary.useLocalStorage = true;
		//AssetLibrary.setStorageFailHandler(showInfoWindow);
		
		AssetLibrary.clearStorage();
		
		trace("using Storage :" +AssetLibrary.useLocalStorage);
		
		stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress);

		
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		//trace("Start");

		assetIndex = AssetLibrary.getIndex();

		assetLoader = AssetLibrary.getLoader();

		//var asset:AssetSWF = new AssetSWF();		
		//assetIndex.addAsset(asset);

		assetIndex.addPathDefinition("testDir", "assets/bigLibs/");

		assetIndex.addFileDefinition("PicPack1", "PicPack1.swf", "testDir", false, "?uId=2");
		assetIndex.addFileDefinition("PicPack2", "PicPack2.swf", "testDir");
		assetIndex.addFileDefinition("PicPack3", "PicPack3.swf", "testDir");
		assetIndex.addFileDefinition("PicPack4", "PicPack4.swf", "testDir");
		assetIndex.addFileDefinition("PicPack5", "PicPack5.swf", "testDir");
		assetIndex.addFileDefinition("PicPack6", "PicPack6.swf", "testDir");
		assetIndex.addFileDefinition("PicPack7", "PicPack7.swf", "testDir");
		assetIndex.addFileDefinition("PicPack8", "PicPack8.swf", "testDir");
		assetIndex.addFileDefinition("PicPack9", "PicPack9.swf", "testDir");
		assetIndex.addFileDefinition("PicPack10", "PicPack10.swf", "testDir");
		assetIndex.addFileDefinition("PicPack11", "PicPack11.swf", "testDir");
		assetIndex.addFileDefinition("PicPack12", "PicPack12.swf", "testDir");



	}
	
//	private function showInfoWindow():void {
//		trace("showInfoWindow");
//		AssetLibrary.forseOpenLocalStorageSettings();
//	}
	
	private function handleKeyPress(e:KeyboardEvent):void {
		trace("######################################################################");
		switch (e.keyCode) {
			case Keyboard.F1:timeShot = getTimer();trace("Load action started for PicPack1...");AssetLibrary.loadAsset("PicPack1", handlePicPack);break;
			case Keyboard.F2:timeShot = getTimer();trace("Load action started for PicPack2...");AssetLibrary.loadAsset("PicPack2", handlePicPack);break;
			case Keyboard.F3:timeShot = getTimer();trace("Load action started for PicPack3...");AssetLibrary.loadAsset("PicPack3", handlePicPack);break;
			case Keyboard.F4:timeShot = getTimer();trace("Load action started for PicPack4...");AssetLibrary.loadAsset("PicPack4", handlePicPack);break;
			case Keyboard.F5:timeShot = getTimer();trace("Load action started for PicPack5...");AssetLibrary.loadAsset("PicPack5", handlePicPack);break;
			case Keyboard.F6:timeShot = getTimer();trace("Load action started for PicPack6...");AssetLibrary.loadAsset("PicPack6", handlePicPack);break;
			case Keyboard.F7:timeShot = getTimer();trace("Load action started for PicPack7...");AssetLibrary.loadAsset("PicPack7", handlePicPack);break;
			case Keyboard.F8:timeShot = getTimer();trace("Load action started for PicPack8...");AssetLibrary.loadAsset("PicPack8", handlePicPack);break;
			case Keyboard.F9:timeShot = getTimer();trace("Load action started for PicPack9...");AssetLibrary.loadAsset("PicPack9", handlePicPack);break;
			case Keyboard.F10:timeShot = getTimer();trace("Load action started for PicPack10...");AssetLibrary.loadAsset("PicPack10", handlePicPack);break;
			case Keyboard.F11:timeShot = getTimer();trace("Load action started for PicPack11...");AssetLibrary.loadAsset("PicPack11", handlePicPack);break;
			case Keyboard.F12:timeShot = getTimer();trace("Load action started for PicPack12...");AssetLibrary.loadAsset("PicPack12", handlePicPack);break;
			case 49:trace("unloading PicPack1...");AssetLibrary.unloadAsset("PicPack1");break;
			case 50:trace("unloading PicPack2...");AssetLibrary.unloadAsset("PicPack2");break;
			case 51:trace("unloading PicPack3...");AssetLibrary.unloadAsset("PicPack3");break;
			case 52:trace("unloading PicPack4...");AssetLibrary.unloadAsset("PicPack4");break;
			case 53:trace("unloading PicPack5...");AssetLibrary.unloadAsset("PicPack5");break;
			case 54:trace("unloading PicPack6...");AssetLibrary.unloadAsset("PicPack6");break;
			case 55:trace("unloading PicPack7...");AssetLibrary.unloadAsset("PicPack7");break;
			case 56:trace("unloading PicPack8...");AssetLibrary.unloadAsset("PicPack8");break;
			case 57:trace("unloading PicPack9...");AssetLibrary.unloadAsset("PicPack9");break;
			case 48:trace("unloading PicPack10...");AssetLibrary.unloadAsset("PicPack10");break;
			case 219:trace("unloading PicPack11...");AssetLibrary.unloadAsset("PicPack11");break;
			case 221:trace("unloading PicPack12...");AssetLibrary.unloadAsset("PicPack12");break;
			default:
			break;
		}
	}
	
	private function handlePicPack(asset:SwfAsset):void {
		trace("GigTest.handlePicPack > asset loaded in ", (getTimer() - timeShot), "ms", "momery:",fpsCounter.mem);
	}



//	private function handleLoadingProgress(event:AssetEvent):void {
		//trace("#>>>Main.handleLoadingProgress > event : " + event);
//	}



//	private function handleXMLLoadStartted(event:AssetEvent):void {
		//trace("Main.handleXMLLoadStartted > event : " + event);
//	}

//	private function handleXMLLoadFinished(e:AssetEvent):void {
		//trace("Main.handleXMLLoadFinished > e : " + e);
//	}

//	private function handleXmlsLoadedFinished(e:AssetEvent):void {
		//trace("Main.handleXmlsLoadedFinished > e : " + e);

//	}

//	private function handleLoadStarted(event:AssetEvent):void {
		//trace("Main.handleLoadStarted > event : " + event);
//	}

//	private function handleLoadFinished(event:AssetEvent):void {
		//trace("Main.handleLoadFinished > event : " + event);
//	}
	
	
	

}
}