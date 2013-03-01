package examples {
import flash.display.Sprite;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.assets.SWFAsset;

public class MinimalLoad extends Sprite {
	
	public function MinimalLoad(){
		
		// add assets to library.
		var assetIndex:AssetLibraryIndex = AssetLibrary.getIndex();
		assetIndex.addFileDefinition("test1", "assets/simpleTest/test1.swf");
		
		// load asset and send it to function.
		AssetLibrary.loadAsset("test1", handleTest1);
	}
	
	private function handleTest1(asset:SWFAsset):void {
		// get instance of object linked in asset library.
		var testSprite:Sprite = asset.getSprite("SquareA_SPR");
		this.addChild(testSprite);
		testSprite.x = 100;
		testSprite.y = 100;
	}

}
}