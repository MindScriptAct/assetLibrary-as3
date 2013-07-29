package depricated {
import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.AssetLibraryLoader;
import mindscriptact.assetLibrary.assets.PicAsset;
import mindscriptact.assetLibrary.assets.SwfAsset;
import mindscriptact.assetLibrary.event.AssetEvent;
import mindscriptact.assetLibrary.core.sharedObject.AssetLibraryStorage;
import mindscriptact.logmaster.DebugMan;

/**
 * Application initial point. PureMVC starter.
 * @author Raimundas Banevicius
 */
//[Frame(factoryClass="assetLibraryTest.Preloader")]
public class MainStorage extends Sprite {
	private var assetIndex:AssetLibraryIndex;
	private var assetLoader:AssetLibraryLoader;
	private var assetLibrarStogarde : AssetLibraryStorage;

	public function MainStorage():void {
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		//trace("Start");

		assetIndex = AssetLibrary.getIndex();

		assetLoader = AssetLibrary.getLoader();

		AssetLibrary.useLocalStorage = true;

		//var asset:AssetSWF = new AssetSWF();
		//assetIndex.addAsset(asset);


		assetLibrarStogarde = new AssetLibraryStorage();

		//
		assetLoader.addEventListener(AssetEvent.XML_LOADING_STARTED, handleXMLLoadStartted);
		assetLoader.addEventListener(AssetEvent.XML_LOADED, handleXMLLoadFinished);
		//assetLoader.addEventListener(AssetEvent.ALL_XMLS_LOADED, handleXmlsLoadedFinished);
		//
		assetLoader.addEventListener(AssetEvent.ASSET_LOADING_STARTED, handleLoadStarted);
		assetLoader.addEventListener(AssetEvent.ASSET_LOADED, handleLoadFinished);
		//
		assetLoader.addEventListener(AssetEvent.PROGRESS, handleLoadingProgress);

		assetLoader.addEventListener(AssetEvent.ALL_PERMANENTS_LOADED, handleAllLoadFinished);

		/*
		// root path test
		AssetLibrary.setRootPath("http://google.com/");
		//*/

		assetIndex.addFileDefinition("test1", "assets/simpleTest/test1.swf");
		assetIndex.addFileDefinition("test2", "assets/simpleTest/test2.swf", null, true);

		assetIndex.addPathDefinition("testDir", "assets/advancedTest/");

		assetIndex.addFileDefinition("test3def", "test3.swf", "testDir");
		assetIndex.addFileDefinition("test4def", "test4.swf", "testDir", true);



		assetIndex.addAssetsToGroup("allFiles", Vector.<String>(["test1", "test2", "test3def", "test4def"]));





		assetIndex.addPathDefinition("versionDir", "assets/versionTest/");

		assetIndex.addFileDefinition("test7", "test7.swf", "versionDir", false);
		assetIndex.addFileDefinition("test8", "test8.swf", "versionDir", true);



		assetIndex.addDefinitionsFromXML("xml/mainAssets.xml");
		assetIndex.addDefinitionsFromXML("xmlMore/secondaryAssets.xml");
		//assetIndex.addAssetsFromXML("xmlMore/unloadAssets.xml", "xmlFileForUnload");
		assetIndex.addDefinitionsFromXML("xmlMore/unloadAssets.xml");


		assetLoader.preloadPermanents();


		assetIndex.addPathDefinition("pictureDir", "assets/pics/");

		assetIndex.addFileDefinition("pngSmiley", "smiley.png", "pictureDir");
		assetIndex.addFileDefinition("jpgSmiley", "smiley.jpg", "pictureDir");
		assetIndex.addFileDefinition("gifSmiley", "smiley.gif", "pictureDir");

		assetIndex.addPathDefinition("soundDir", "assets/sounds/");

		assetIndex.addFileDefinition("nin_the_warning", "nin_the_warning.mp3", "soundDir");


		//assetIndex.addPathDefinition("testPath", "assets/test", true, "_");
		//

	/*
	   //permanens protection ..
	   AssetLibrary.removePermanentAssetProtection();
	 //*/


	 	AssetLibrary.loadAsset("pngSmiley", handlePic);
		AssetLibrary.loadAsset("jpgSmiley", handlePic);
		AssetLibrary.loadAsset("gifSmiley", handlePic);

	}



	private function handleLoadingProgress(event:AssetEvent):void {
		//trace("#>>>Main.handleLoadingProgress > event : " + event);
	}



	private function handleXMLLoadStartted(event:AssetEvent):void {
		//trace("Main.handleXMLLoadStartted > event : " + event);
	}

	private function handleXMLLoadFinished(e:AssetEvent):void {
		//trace("Main.handleXMLLoadFinished > e : " + e);
	}

	//private function handleXmlsLoadedFinished(e:AssetEvent):void {
		//trace("Main.handleXmlsLoadedFinished > e : " + e);

	//}

	private function handleLoadStarted(event:AssetEvent):void {
		//trace("Main.handleLoadStarted > event : " + event);
	}

	private function handleLoadFinished(event:AssetEvent):void {
		//trace("Main.handleLoadFinished > event : " + event);
	}



	private function handleAllLoadFinished(event:AssetEvent):void {
		//trace("Main.handleAllLoadFinished > event : " + event);
		//
		AssetLibrary.loadAsset("test1", handleTest1);
		//
		var circle:Sprite = AssetLibrary.getSWFSprite("test2", "CircleA_SPR");
		this.addChild(circle);
		circle.x = 50;
		circle.y = 50;
		//
		AssetLibrary.loadAsset("test3def", handleTest3);
		//
		//AssetLibrary.restrictAccsessToNonPermanents = false;
		//
		var circle2:Sprite = AssetLibrary.getSWFSprite("test4def", "CircleB_SPR");
		this.addChild(circle2);
		circle2.x = 250;
		circle2.y = 50;
		//


		AssetLibrary.loadAsset("test5", handleTest5);
		//
		var circle3:Sprite = AssetLibrary.getSWFSprite("test6", "CircleC_SPR");
		this.addChild(circle3);
		circle3.x = 450;
		circle3.y = 50;
		//


		AssetLibrary.loadAsset("test7", handleTest7);
		//
		var circle4:Sprite = AssetLibrary.getSWFSprite("test8", "CircleD_SPR");
		this.addChild(circle4);
		circle4.x = 650;
		circle4.y = 50;
		//
	}

	private function handleTest1(asset:SwfAsset):void {
		//trace("Main.handleTest1 > asset : " + asset);

		var anim:MovieClip = asset.getMovieClip("AnimMC");
		this.addChild(anim);
		anim.x = 100;
		anim.y = 300;

		var testSprite:Sprite = asset.getSprite("SquareA_SPR");
		this.addChild(testSprite);
		testSprite.x = 100;
		testSprite.y = 100;
	}

	private function handleTest3(asset:SwfAsset):void {
		//trace("Main.handleTest3 > asset : " + asset);
		var testSprite:Sprite = asset.getSprite("SquareB_SPR");
		this.addChild(testSprite);
		testSprite.x = 300;
		testSprite.y = 100;
	}

	private function handleTest7(asset:SwfAsset):void {
		//trace("Main.handleTest7 > asset : " + asset);
		var testSprite:Sprite = asset.getSprite("SquareD_SPR");
		this.addChild(testSprite);
		testSprite.x = 700;
		testSprite.y = 100;
	}

	private function handleTest5(asset:SwfAsset):void {
		//trace("Main.handleTest5 > asset : " + asset);
		var testSprite:Sprite = asset.getSprite("SquareC_SPR");
		this.addChild(testSprite);
		testSprite.x = 500;
		testSprite.y = 100;
		//
		/*
		   //permanents protection ..
		   assetIndex.addAssetDefinition(new AssetDefinition("test2again", "assets/simpleTest/test2again.swf", AssetType.SWF, true));
		 //*/

		/*
		   // pernament unload test
		   AssetLibrary.removePermanentAssetProtection();
		   AssetLibrary.unloadAsset("test2");


		   var circle:Sprite = AssetLibrary.getAssetSprite("test2", "CircleA_SPR");
		   this.addChild(circle);
		   circle.x = 400;
		   circle.y = 400;
		 //*/



		// load set of filse from xml


		//assetIndex.unloadGroupAssets("xmlFileForUnload");

	}

//	private function testSomeStuff():void {
		//trace("Main.testSomeStuff");


		/*
		// group asset load
		AssetLibrary.unloadGroupAssets("allFiles");
		//*/

		/*
		// group asset load
		AssetLibrary.unloadAsset("test1");
		AssetLibrary.unloadAsset("test3def");
		AssetLibrary.unloadAsset("test5");

		//AssetLibrary.loadGroupAssets("allFiles");

		//AssetLibrary.loadGroupAssets("loadTest");
		AssetLibrary.unloadGroupAssets("loadTest");

		AssetLibrary.loadAsset("test5", handleTest5);
		//*/

		/*
		// all non permanents unload
		AssetLibrary.unloadAllNonPermanents();
		AssetLibrary.loadAsset("test5", handleTest5);
		//*/



		/*
		var testTime:int = getTimer();
		var asset:AssetMP3 = ShareDemo.get("littleSound") as AssetMP3;
		trace("geting took : ", (getTimer() - testTime));
		asset.play();
		//*/

//		AssetLibrary.loadAsset("nin_the_warning", handleSound);
//	}

//	private function handleSound(asset:Mp3Asset):void {
//		trace("Main.handleSound > asset : " + asset);
//
//		//*
//		var testTime:int = getTimer();
//		assetLibrarStogarde.store("littleSound","", asset as ByteArray);
//		trace("storing took : ", (getTimer() - testTime));
//		//*/
//
//		asset.play();
//	}

	private function handlePic(asset:PicAsset):void {
		trace("Main.handlePic > asset : " + asset);

		var bitMap:Bitmap = asset.getBitmap();
		this.addChild(bitMap);
		bitMap.x = Math.random() * 500 + 50;
		bitMap.y = Math.random() * 100 + 300;

	}


}
}