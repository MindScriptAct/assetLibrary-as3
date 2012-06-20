package assetLibraryTest {
import com.logmaster.DebugMan;
import com.mindscriptact.assetLibrary.sharedObject.ShareDemo;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.utils.ByteArray;
import flash.utils.getTimer;

/**
 * ...
 * @author ...
 */
public class SharedObjectTest extends Sprite {

	public function SharedObjectTest(){
		var loader:URLLoader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.BINARY;
		loader.addEventListener(Event.COMPLETE, handleFileLoad);
		//


		//loader.load(new URLRequest("assets/sharedObjectTest/test.swf"));

		var testTime:int = getTimer();
		convertToMovieClip(ShareDemo.get("aaaaaaaaaaaha") as ByteArray);
		DebugMan.info("GET : ", (getTimer() - testTime));

	}

	private function handleFileLoad(event:Event):void {
		DebugMan.info("SharedObjectTest.handleFileLoad > event : " + event);
		//this.addChild(event)

		convertToMovieClip((event.target as URLLoader).data as ByteArray);

		var testTime:int = getTimer();
		ShareDemo.store("aaaaaaaaaaaha", (event.target as URLLoader).data as ByteArray);
		DebugMan.info("STORE : ", (getTimer() - testTime));
	}

	private function convertToMovieClip(data:ByteArray):void {
		var converter:Loader = new Loader();
		converter.contentLoaderInfo.addEventListener(Event.COMPLETE, onConvertFinished);
		converter.loadBytes(data);
	}

	private function onConvertFinished(event:Event):void {
		DebugMan.info("SharedObjectTest.onConvertFinished > event : " + event);
		this.addChild((event.target as LoaderInfo).content);
	}

}

}