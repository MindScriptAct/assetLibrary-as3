package assetLibraryTest {
import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.AssetLibraryLoader;
import mindscriptact.assetLibrary.assets.PICAsset;
import mindscriptact.assetLibrary.event.AssetEvent;

/**
 * @author Raimundas Banevicius
 */
public class PicTest extends Sprite {
	private var assetIndex:AssetLibraryIndex;
	private var assetLoader:AssetLibraryLoader;
	private var testRectangle:Shape;

	public function PicTest():void {
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		
		this.addChild(new Stats());
		//DebugMan.info("Start");

		assetIndex = AssetLibrary.getIndex();

		assetLoader = AssetLibrary.getLoader();
		assetLoader.addEventListener(AssetEvent.ALL_PERMANENTS_LOADED, handleAllLoadFinished);
		
		
		
		
		assetIndex.addFileDefinition("jpgTest", "assets/pics/smiley.jpg", null, true);
		assetIndex.addFileDefinition("pngTest", "assets/pics/smiley.png", null, true);
		assetIndex.addFileDefinition("gifTest", "assets/pics/smiley.gif", null, true);

		
		
		
		assetLoader.preloadPermanents();
		
		
		
		
		
		
		
		// for testing how bitmap update affects the pictures.
		testRectangle = new Shape();
		testRectangle.graphics.lineStyle(5, 0xFF0000);
		testRectangle.graphics.beginFill(0x00FFFF);
		testRectangle.graphics.drawRect(5, 5, 10, 10);
		testRectangle.graphics.endFill();
		this.addChild(testRectangle);
		
		testRectangle.x = 100;
		testRectangle.y = 20;
		
		
	}


	private function handleAllLoadFinished(event:AssetEvent):void {
		
		// pernament jpg test.
		var jpgPic:Bitmap = AssetLibrary.getPICBitmap("jpgTest");
		this.addChild(jpgPic);
		jpgPic.x = 0;
		jpgPic.y = 50;
		
		// original pic is modified, all copies, and clones will have this update from now on.
		jpgPic.bitmapData.draw(testRectangle);
		
		// pernament png test
		var pngPic:Bitmap = AssetLibrary.getPICBitmap("pngTest");
		this.addChild(pngPic);
		pngPic.x = 150;
		pngPic.y = 200;
	
		// pernament gif test.
		var gifPic:Bitmap = AssetLibrary.getPICBitmap("gifTest");
		this.addChild(gifPic);
		gifPic.x = 300;
		gifPic.y = 400;		
		
		// termporal load test.
		AssetLibrary.loadAsset("jpgTest", handleJpgAsset, [0+350, 50]);
		AssetLibrary.loadAsset("pngTest", handlePngAsset, [150+350, 200]);
		AssetLibrary.loadAsset("gifTest", handleGifAsset, [300+350, 400]);
		
	}

	private function handleJpgAsset(asset:PICAsset, posX:int, posY:int):void {
		// original pic was modified. modifications should be visible in all copies. 
		var pic:Bitmap = asset.getBitmap();
		this.addChild(pic);
		pic.x = posX;
		pic.y = posY;
		// clones also gets all changes done to original pic.
		var picClone:Bitmap = asset.getClonedBitmap();
		this.addChild(picClone);
		picClone.x = posX + 100;
		picClone.y = posY;		
	}
	
	private function handlePngAsset(asset:PICAsset, posX:int, posY:int):void {
		var pic:Bitmap = asset.getBitmap();
		this.addChild(pic);
		pic.x = posX;
		pic.y = posY;
		
		// clone was not created, olll modifications to pic should be visible to all copies of it.
		// all new copies and clones will have these updates from now on.
		pic.bitmapData.draw(testRectangle);
	}	
	
	private function handleGifAsset(asset:PICAsset, posX:int, posY:int):void {
		var pic:Bitmap = asset.getClonedBitmap();
		this.addChild(pic);
		pic.x = posX;
		pic.y = posY;
		// clone is created, original pic was not changed.
		// onli new clon is updated, without damaging original picture.
		pic.bitmapData.draw(testRectangle);
	}	

}
}