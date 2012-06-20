package assetLibraryTest {
import com.mindscriptact.assetLibrary.AssetLibrary;
import com.mindscriptact.assetLibrary.AssetLibraryIndex;
import com.mindscriptact.assetLibrary.AssetLibraryLoader;
import com.mindscriptact.assetLibrary.assets.SWFAsset;
import com.mindscriptact.assetLibrary.event.AssetEvent;
import com.mindscriptact.logmaster.DebugMan;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.utils.getTimer;

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
		
		var testtt:Loader = new Loader();
		
		AssetLibrary.useLocalStoradge = true;
		AssetLibrary.setStoradgeFailHandler(showInfoWindow);
		
		//AssetLibrary.clearLocalStoradge();
		
		DebugMan.info("using storadge :" +AssetLibrary.isUsingLoralStoradge);
		
		stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress);

		
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		//DebugMan.info("Start");

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
	
	private function showInfoWindow():void {
		DebugMan.info("showInfoWindow");
		AssetLibrary.forseOpenLocalStorageSettings();
	}
	
	private function handleKeyPress(e:KeyboardEvent):void {
		DebugMan.info("######################################################################");
		switch (e.keyCode) {
			case Keyboard.F1:timeShot = getTimer();DebugMan.info("Load action started for PicPack1...");AssetLibrary.sendAssetToFunction("PicPack1", handlePicPack);break;
			case Keyboard.F2:timeShot = getTimer();DebugMan.info("Load action started for PicPack2...");AssetLibrary.sendAssetToFunction("PicPack2", handlePicPack);break;
			case Keyboard.F3:timeShot = getTimer();DebugMan.info("Load action started for PicPack3...");AssetLibrary.sendAssetToFunction("PicPack3", handlePicPack);break;
			case Keyboard.F4:timeShot = getTimer();DebugMan.info("Load action started for PicPack4...");AssetLibrary.sendAssetToFunction("PicPack4", handlePicPack);break;
			case Keyboard.F5:timeShot = getTimer();DebugMan.info("Load action started for PicPack5...");AssetLibrary.sendAssetToFunction("PicPack5", handlePicPack);break;
			case Keyboard.F6:timeShot = getTimer();DebugMan.info("Load action started for PicPack6...");AssetLibrary.sendAssetToFunction("PicPack6", handlePicPack);break;
			case Keyboard.F7:timeShot = getTimer();DebugMan.info("Load action started for PicPack7...");AssetLibrary.sendAssetToFunction("PicPack7", handlePicPack);break;
			case Keyboard.F8:timeShot = getTimer();DebugMan.info("Load action started for PicPack8...");AssetLibrary.sendAssetToFunction("PicPack8", handlePicPack);break;
			case Keyboard.F9:timeShot = getTimer();DebugMan.info("Load action started for PicPack9...");AssetLibrary.sendAssetToFunction("PicPack9", handlePicPack);break;
			case Keyboard.F10:timeShot = getTimer();DebugMan.info("Load action started for PicPack10...");AssetLibrary.sendAssetToFunction("PicPack10", handlePicPack);break;
			case Keyboard.F11:timeShot = getTimer();DebugMan.info("Load action started for PicPack11...");AssetLibrary.sendAssetToFunction("PicPack11", handlePicPack);break;
			case Keyboard.F12:timeShot = getTimer();DebugMan.info("Load action started for PicPack12...");AssetLibrary.sendAssetToFunction("PicPack12", handlePicPack);break;
			case 49:DebugMan.info("unloading PicPack1...");AssetLibrary.unloadAsset("PicPack1");break;
			case 50:DebugMan.info("unloading PicPack2...");AssetLibrary.unloadAsset("PicPack2");break;
			case 51:DebugMan.info("unloading PicPack3...");AssetLibrary.unloadAsset("PicPack3");break;
			case 52:DebugMan.info("unloading PicPack4...");AssetLibrary.unloadAsset("PicPack4");break;
			case 53:DebugMan.info("unloading PicPack5...");AssetLibrary.unloadAsset("PicPack5");break;
			case 54:DebugMan.info("unloading PicPack6...");AssetLibrary.unloadAsset("PicPack6");break;
			case 55:DebugMan.info("unloading PicPack7...");AssetLibrary.unloadAsset("PicPack7");break;
			case 56:DebugMan.info("unloading PicPack8...");AssetLibrary.unloadAsset("PicPack8");break;
			case 57:DebugMan.info("unloading PicPack9...");AssetLibrary.unloadAsset("PicPack9");break;
			case 48:DebugMan.info("unloading PicPack10...");AssetLibrary.unloadAsset("PicPack10");break;
			case 219:DebugMan.info("unloading PicPack11...");AssetLibrary.unloadAsset("PicPack11");break;
			case 221:DebugMan.info("unloading PicPack12...");AssetLibrary.unloadAsset("PicPack12");break;
			default:
			break;
		}
	}
	
	private function handlePicPack(asset:SWFAsset):void {
		DebugMan.info("GigTest.handlePicPack > asset loaded in ", (getTimer() - timeShot), "ms", "momery:",fpsCounter.mem);
	}



	private function handleLoadingProgress(event:AssetEvent):void {
		//DebugMan.info("#>>>Main.handleLoadingProgress > event : " + event);
	}



	private function handleXMLLoadStartted(event:AssetEvent):void {
		//DebugMan.info("Main.handleXMLLoadStartted > event : " + event);
	}

	private function handleXMLLoadFinished(e:AssetEvent):void {
		//DebugMan.info("Main.handleXMLLoadFinished > e : " + e);
	}

	private function handleXmlsLoadedFinished(e:AssetEvent):void {
		//DebugMan.info("Main.handleXmlsLoadedFinished > e : " + e);

	}

	private function handleLoadStarted(event:AssetEvent):void {
		//DebugMan.info("Main.handleLoadStarted > event : " + event);
	}

	private function handleLoadFinished(event:AssetEvent):void {
		//DebugMan.info("Main.handleLoadFinished > event : " + event);
	}
	
	
	

}
}