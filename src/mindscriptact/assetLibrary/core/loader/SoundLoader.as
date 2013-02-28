package mindscriptact.assetLibrary.core.loader {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.media.Sound;
import flash.net.URLRequest;
import mindscriptact.assetLibrary.core.AssetDefinition;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;

/**
 * ...
 * @author ...
 */
public class SoundLoader extends EventDispatcher {
	private var _sound:Sound;
	assetlibrary var asssetDefinition:AssetDefinition;
	
	public function SoundLoader() {
	}
	
	assetlibrary function get sound():Sound {
		return _sound;
	}
	
	assetlibrary function load(urlRequest:URLRequest):void {
		_sound = new Sound();
		_sound.addEventListener(Event.COMPLETE, handleSoundLoad);
		_sound.addEventListener(ProgressEvent.PROGRESS, handleSoundProgress);
		_sound.addEventListener(IOErrorEvent.IO_ERROR, handleSoundError);
		_sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSoundError);
		//_sound.addEventListener(Event.ID3, handleId3);
		_sound.load(urlRequest);
	}
	
	private function handleSoundLoad(event:Event):void {
		dispatchEvent(event);
	}
	
	private function handleSoundProgress(event:ProgressEvent):void {
		dispatchEvent(event);
	}
	
	private function handleSoundError(event:IOErrorEvent):void {
		dispatchEvent(event);
	}
	
//	private function handleId3(event:Event):void {
//		dispatchEvent(event);
//	}
	
	assetlibrary function dispose():void {
		use namespace assetlibrary;
		_sound.removeEventListener(Event.COMPLETE, handleSoundLoad);
		_sound.removeEventListener(ProgressEvent.PROGRESS, handleSoundProgress);
		_sound.removeEventListener(IOErrorEvent.IO_ERROR, handleSoundError);
		_sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSoundError);
		//_sound.removeEventListener(Event.ID3, id3Handler);
		_sound = null;
		asssetDefinition = null;
	}
}

}