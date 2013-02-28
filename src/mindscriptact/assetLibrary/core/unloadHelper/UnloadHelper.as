package mindscriptact.assetLibrary.core.unloadHelper {
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.getTimer;
import flash.utils.Timer;
import mindscriptact.assetLibrary.AssetLibrary;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;

/**
 * ...
 * @author Deril
 */
public class UnloadHelper {
	private var unloadTimer:Timer;
	private var assetsForUnload:Dictionary;
	
	public function UnloadHelper() {
		assetsForUnload = new Dictionary();
	}
	
	assetlibrary function addAssetTime(assetId:String, assetKeepTime:int):void {
		if (assetKeepTime == int.MAX_VALUE || assetKeepTime <= 0) {
			if (assetsForUnload[assetId]) {
				delete assetsForUnload[assetId];
			}
		} else {
			assetsForUnload[assetId] = getTimer() + (assetKeepTime * 1000);
		}
	}
	
	assetlibrary function setUnloadIntervalTime(autoUnloadIntervalTime:int):void {
		if (autoUnloadIntervalTime > 0) {
			if (!unloadTimer) {
				unloadTimer = new Timer(autoUnloadIntervalTime * 1000);
				unloadTimer.addEventListener(TimerEvent.TIMER, handleAutoUnload);
			} else {
				unloadTimer.delay = autoUnloadIntervalTime * 1000;
			}
			if (!unloadTimer.running) {
				unloadTimer.start();
			}
		} else {
			if (unloadTimer) {
				unloadTimer.stop();
			}
		}
	}
	
	// TODO: optimize. Current solution will use 140 ms to handle 100000 size dictionary. It should be ok for most cases. But still its good idea to optivime it.
	private function handleAutoUnload(event:TimerEvent):void {
		var currentTyme:int = getTimer();
		for (var assetId:String in assetsForUnload) {
			if (assetsForUnload[assetId] < currentTyme) {
				AssetLibrary.unloadAsset(assetId);
				delete assetsForUnload[assetId];
			}
		}
	}

}

}