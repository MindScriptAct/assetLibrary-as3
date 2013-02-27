package assetLibraryTest {
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.AssetLibraryLoader;
import mindscriptact.assetLibrary.assets.SWFAsset;
import mindscriptact.assetLibrary.event.AssetEvent;
import mindscriptact.logmaster.DebugMan;

/**
 * Application initial point. PureMVC starter.
 * @author Raimundas Banevicius
 */
public class MainRemote extends Sprite {
	private var assetIndex:AssetLibraryIndex;
	private var assetLoader:AssetLibraryLoader;
	private var myTextField:TextField;

	public function MainRemote():void {
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		DebugMan.info("Start");

		assetIndex = AssetLibrary.getIndex();

		assetLoader = AssetLibrary.getLoader();

		//var asset:AssetSWF = new AssetSWF();		
		//assetIndex.addAsset(asset);


		myTextField = new TextField();
		this.addChild(myTextField);
		myTextField.text = 'TextLabel...';
		myTextField.width = 600;

		var newFormat:TextFormat = new TextFormat();
		newFormat.size = 16;
		newFormat.font = 'Verdana';

		myTextField.setTextFormat(newFormat);


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
		 //*/
		AssetLibrary.setRootPath("http://www.mindscriptact.com/");



		assetIndex.addAssetsFromXML("temp/remoteDir/remoteFiles.xml?r=2");



		assetLoader.preloadPermanents();

		//assetIndex.addPathDefinition("testPath", "assets/test", true, "_");
		//

	/*
	   //permanens protection ..
	   AssetLibrary.removePermanentAssetProtection();
	 //*/



	}



	private function handleLoadingProgress(event:AssetEvent):void {
		DebugMan.info("#>>>Main.handleLoadingProgress > event : " + event);
		myTextField.text = event.filesLoaded + "/" + event.filesQueued + " >>> " + event.bytesLoaded + ":" + event.bytesTotal;
	}



	private function handleXMLLoadStartted(event:AssetEvent):void {
		DebugMan.info("Main.handleXMLLoadStartted > event : " + event);
		myTextField.text = event.filesLoaded + "/" + event.filesQueued + " >>> " + event.bytesLoaded + ":" + event.bytesTotal;
	}

	private function handleXMLLoadFinished(event:AssetEvent):void {
		DebugMan.info("Main.handleXMLLoadFinished > event : " + event);
		myTextField.text = event.filesLoaded + "/" + event.filesQueued + " >>> " + event.bytesLoaded + ":" + event.bytesTotal;

	}

//	private function handleXmlsLoadedFinished(event:AssetEvent):void {
//		DebugMan.info("Main.handleXmlsLoadedFinished > event : " + event);
//		myTextField.text = event.filesLoaded + "/" + event.filesQueued + " >>> " + event.bytesLoaded + ":" + event.bytesTotal;
//	}

	private function handleLoadStarted(event:AssetEvent):void {
		DebugMan.info("Main.handleLoadStarted > event : " + event);
		myTextField.text = event.filesLoaded + "/" + event.filesQueued + " >>> " + event.bytesLoaded + ":" + event.bytesTotal;

	}

	private function handleLoadFinished(event:AssetEvent):void {
		DebugMan.info("Main.handleLoadFinished > event : " + event);
		myTextField.text = event.filesLoaded + "/" + event.filesQueued + " >>> " + event.bytesLoaded + ":" + event.bytesTotal;

	}



	private function handleAllLoadFinished(event:AssetEvent):void {
		myTextField.text = event.filesLoaded + "/" + event.filesQueued + " >>> " + event.bytesLoaded + ":" + event.bytesTotal;
		DebugMan.info("Main.handleAllLoadFinished > event : " + event);
		AssetLibrary.sendAssetToFunction("RemoteTest", handleTest);
	}

	private function handleTest(asset:SWFAsset):void {
		DebugMan.info("Main.handleTest > asset : " + asset);

		var testSprite:Sprite = asset.getSprite("WaterTigerSPR");
		this.addChild(testSprite);
		testSprite.x = 50;
		testSprite.y = 50;

		testSprite.scaleX = testSprite.scaleY = 0.2;
	}


}
}