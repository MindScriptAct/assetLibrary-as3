package depricated {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.AssetLibraryLoader;
import mindscriptact.assetLibrary.assets.Mp3Asset;
import mindscriptact.assetLibrary.event.AssetEvent;

/**
 * @author Raimundas Banevicius
 */
public class SoundTest extends Sprite {
	private var assetIndex:AssetLibraryIndex;
	private var assetLoader:AssetLibraryLoader;
//	private var testRectangle:Shape;
	
	public function SoundTest():void {
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		
		this.addChild(new Stats());
		//trace("Start");
		
		assetIndex = AssetLibrary.getIndex();
		
		assetLoader = AssetLibrary.getLoader();
		assetLoader.addEventListener(AssetEvent.ALL_PERMANENTS_LOADED, handleAllLoadFinished);
		
		assetIndex.addFileDefinition("mp3Test", "assets/sounds/nin_the_warning.mp3", null, true);
		assetIndex.addFileDefinition("mp3Shredder", "assets/sounds/paper-shredder-2.mp3");
		assetIndex.addFileDefinition("mp3BlaBla", "assets/sounds/blah-blah-blah.mp3");
		
		assetLoader.preloadPermanents();
	
	}
	
	private function handleAllLoadFinished(event:AssetEvent):void {
		/*
		   var sound:Sound = AssetLibrary.getMP3Sound("mp3Test");
		   sound.play();
		 //*/
		
		AssetLibrary.playMP3("mp3Test");
		AssetLibrary.playMP3NowOrNever("mp3BlaBla");
		AssetLibrary.loadAsset("mp3Shredder", handleMp3);
		
		this.stage.addEventListener(MouseEvent.CLICK, handleFirstStageClick);
	}
	
	private function handleFirstStageClick(e:MouseEvent):void {
		this.stage.removeEventListener(MouseEvent.CLICK, handleFirstStageClick);
		this.stage.addEventListener(MouseEvent.CLICK, handleSeccondStageClick);
		//
		AssetLibrary.stopMP3Channels("mp3Test");
		AssetLibrary.playMP3NowOrNever("mp3BlaBla", 0, 50);
	}
	
	private function handleSeccondStageClick(e:MouseEvent):void {
		this.stage.removeEventListener(MouseEvent.CLICK, handleSeccondStageClick);
		//
		AssetLibrary.stopAllMP3Sounds();
	}
	
	private function handleMp3(asset:Mp3Asset):void {
		asset.play(0, 5);
	}
}
}