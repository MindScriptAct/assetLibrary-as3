package mindscriptact.assetLibrary.assets {
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

/**
 * Wraper for .mp3 sound asset
 * @author Raimundas Banevicius
 */
public class MP3Asset extends AssetAbstract {
	private var soundChannels:Vector.<SoundChannel> = new Vector.<SoundChannel>();
	
	public function MP3Asset(assetId:String) {
		super(assetId);
	}
	
	/**
	 * Starts standart mp3 asset playBack.
	 * The only thing you can do if you use this method after its started : use stopAllChannels() to stop all sounds of this asset.
	 * If you need more controll over how you want to use sound = use getSound() instead.
	 * @param	startTime	The initial position in milliseconds at which playback should start.
	 * @param	loops	Defines the number of times a sound loops back to the startTime value
	 * before the sound channel stops playback.
	 * @param	sndTransform	The initial SoundTransform object assigned to the sound channel.
	 */
	public function play(startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void {
		var channel:SoundChannel = (content as Sound).play(startTime, loops, sndTransform);
		channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
		this.soundChannels.push(channel);
	}
	
	/**
	 * Stops all sounds, started from this asset.
	 */
	public function stopAllChannels():void {
		while (soundChannels.length) {
			soundChannels.pop().stop();
		}
	}
	
	/**
	 * Get sound object.
	 * @return	Sound object.
	 */
	public function getSound():Sound {
		return content as Sound;
	}
	
	//----------------------------------
	//     internal
	//----------------------------------
	
	private function handleSoundComplete(event:Event):void {
		for (var i:int = 0; i < soundChannels.length; i++) {
			if (soundChannels[i] == event.target) {
				soundChannels[i].stop();
				soundChannels.splice(i, 1);
			}
		}
	}

}
}