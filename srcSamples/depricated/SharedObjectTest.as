package depricated {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import mindscriptact.assetLibrary.core.sharedObject.AssetLibraryStoradge;
	import mindscriptact.logmaster.DebugMan;

/**
 * ...
 * @author ...
 */
public class SharedObjectTest extends Sprite {
	private var assetLibrarStogarde : AssetLibraryStoradge;

	public function SharedObjectTest(){
		var loader:URLLoader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, handleFileLoad);
		//


		//loader.load(new URLRequest("assets/sharedObjectTest/test.swf"));

		assetLibrarStogarde = new AssetLibraryStoradge();


		var testTime:int = getTimer();
		convertToMovieClip(assetLibrarStogarde.get("aaaaaaaaaaaha", "") as ByteArray);
		trace("GET : ", (getTimer() - testTime));

	}

	private function handleFileLoad(event:Event):void {
		trace("SharedObjectTest.handleFileLoad > event : " + event);
		//this.addChild(event)

		convertToMovieClip((event.target as URLLoader).data as ByteArray);

		var testTime:int = getTimer();
		assetLibrarStogarde.store("aaaaaaaaaaaha","", (event.target as URLLoader).data as ByteArray);
		trace("STORE : ", (getTimer() - testTime));
	}

	private function convertToMovieClip(data:ByteArray):void {
		var converter:Loader = new Loader();
		converter.contentLoaderInfo.addEventListener(Event.COMPLETE, onConvertFinished);
		converter.loadBytes(data);
	}

	private function onConvertFinished(event:Event):void {
		trace("SharedObjectTest.onConvertFinished > event : " + event);
		this.addChild((event.target as LoaderInfo).content);
	}

}

}