package assetLibraryTest {
import com.mindscriptact.assetLibrary.AssetLibrary;
import com.mindscriptact.assetLibrary.AssetLibraryIndex;
import com.mindscriptact.assetLibrary.AssetLibraryLoader;
import com.mindscriptact.assetLibrary.assets.PICAsset;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getTimer;

/**
 * Application initial point. PureMVC starter.
 * @author Raimundas Banevicius
 */
public class AutoUnloadTest extends Sprite {
	private var assetIndex:AssetLibraryIndex;
	private var assetLoader:AssetLibraryLoader;
	
	public function AutoUnloadTest():void {
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
		
		AssetLibrary.sendAssetToFunction("pngSmiley", handlePic, [10, 10], 5);
		AssetLibrary.sendAssetToFunction("jpgSmiley", handlePic, [200, 200], 15);
		AssetLibrary.sendAssetToFunction("gifSmiley", handlePic, [350, 350], 50);
		
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