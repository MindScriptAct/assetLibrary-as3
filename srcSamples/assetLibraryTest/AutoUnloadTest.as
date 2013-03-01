package assetLibraryTest {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getTimer;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.assets.PICAsset;

/**
 * Application initial point. PureMVC starter.
 * @author Raimundas Banevicius
 */
public class AutoUnloadTest extends Sprite {
	private var assetIndex:AssetLibraryIndex;
//	private var assetLoader:AssetLibraryLoader;
	private var startTest:int;
	
	public function AutoUnloadTest():void {
		
		startTest = getTimer();
		
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		assetIndex = AssetLibrary.getIndex();
		
		assetIndex.addPathDefinition("pictureDir", "assets/pics/");
		
		assetIndex.addFileDefinition("pngSmiley", "smiley.png", "pictureDir");
		assetIndex.addFileDefinition("jpgSmiley", "smiley.jpg", "pictureDir");
		assetIndex.addFileDefinition("gifSmiley", "smiley.gif", "pictureDir");
		
		AssetLibrary.loadAsset("pngSmiley", handlePic, [10, 10], 5);
		AssetLibrary.loadAsset("jpgSmiley", handlePic, [200, 200], 15);
		AssetLibrary.loadAsset("gifSmiley", handlePic, [350, 350], 50);
		
		trace(getTimer() - startTest);
		
	}
	
	private function handlePic(asset:PICAsset, xPos:int, yPos:int):void {
		//DebugMan.info("Main.handlePic > asset : " + asset);
		
		var bitMap:Bitmap = asset.getBitmap();
		this.addChild(bitMap);
		bitMap.x = xPos;
		bitMap.y = yPos;
	
	}

}
}