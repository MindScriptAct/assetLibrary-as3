package mindscriptact.assetLibrary.core.localStorage {
import flash.events.NetStatusEvent;
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;
import flash.system.Security;
import flash.system.SecurityPanel;
import flash.system.System;
import flash.utils.ByteArray;
import flash.utils.getTimer;

//import mindscriptact.logmaster.DebugMan;

/**
 * Local shared object Storage manager.
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class AssetLibraryStorage {
	
	static private var projectId:String;
	
	static private var handleUserAction:Function;
	
	static private var mySharedObjectIndex:SharedObject;
	
	private var errorHandler:Function;
	
	public function AssetLibraryStorage(projectId:String, errorHandler:Function) {
		AssetLibraryStorage.projectId = projectId;
		this.errorHandler = errorHandler;
		mySharedObjectIndex = SharedObject.getLocal(projectId + "_Asset_Lybrary");
	}
	
	public function canUseStore():Boolean {
		var retVal:Boolean = false;
		var timeCheck:int = getTimer();
		mySharedObjectIndex.data.__$$_can_Use_Check = 1;
		var flushStatus:String = null;
		try {
			flushStatus = mySharedObjectIndex.flush();
			retVal = true;
		} catch (error:Error) {
			errorHandler(new Error("AssetLibraryStorage could not write SharedObject to disk, flushStatus:", flushStatus));
		}
		//trace(" !! canUseStoreCheck :" + (getTimer() - timeCheck));
		return retVal;
	}
	
	public function checkVersion(id:String, path:String):Boolean {
		var retVal:Boolean = false;
		//var mySharedObjectIndex:SharedObject = SharedObject.getLocal(projectId + "_Asset_Lybrary");
		
		// TODO : implement
		
		return retVal;
	}
	
	public function store(id:String, path:String, byteData:ByteArray):Boolean {
		var retVal:Boolean = true;
		// Create/get a shared-objects
		var mySharedObject:SharedObject = SharedObject.getLocal(projectId + "_" + id);
		// Store data
		mySharedObject.data.byteArray = byteData;
		mySharedObjectIndex.data[id] = path;
		try {
			mySharedObject.flush();
			mySharedObjectIndex.flush();
		} catch (error:Error) {
			delete mySharedObject.data.byteArray;
			delete mySharedObjectIndex.data[id];
			retVal = false;
		}
		return retVal;
	}
	
	public function get(id:String, path:String):ByteArray {
		var retVal:ByteArray;
		
		var mySharedObject:SharedObject = SharedObject.getLocal(projectId + "_" + id);
		if (mySharedObjectIndex.data[id] == path) {
			retVal = mySharedObject.data.byteArray as ByteArray;
		} else {
			if (mySharedObjectIndex.data[id] != null) {
				delete mySharedObject.data.byteArray;
				delete mySharedObjectIndex.data[id];
			}
		}
		return retVal;
	}
	
	static public function clearSharedObject(objectName:String):void {
		var sharedObject:SharedObject = SharedObject.getLocal(objectName);
		sharedObject.clear();
	}
	
	public function getProjectId():String {
		return projectId;
	}
	
	static public function requestStorageSpace(handleUserAction:Function, size:Number):void {
		if (!mySharedObjectIndex) {
			mySharedObjectIndex = SharedObject.getLocal(projectId + "_Asset_Lybrary");
		}
		
		var flushStatus:String = null;
		try {
			flushStatus = mySharedObjectIndex.flush(size * 1024 * 1024);
		} catch (error:Error) {
			handleUserAction(false);
			return;
		}
		
		if (flushStatus != null) {
			switch (flushStatus) {
				case SharedObjectFlushStatus.PENDING: 
					AssetLibraryStorage.handleUserAction = handleUserAction;
					mySharedObjectIndex.addEventListener(NetStatusEvent.NET_STATUS, handleFlushStatus);
					break;
				case SharedObjectFlushStatus.FLUSHED: 
					handleUserAction(true);
					break;
			}
		}
	}
	
	static public function openStorageSettings():void {
		Security.showSettings(SecurityPanel.LOCAL_STORAGE);
	}
	
	static private function handleFlushStatus(event:NetStatusEvent):void {
		mySharedObjectIndex.removeEventListener(NetStatusEvent.NET_STATUS, handleFlushStatus);
		switch (event.info.code) {
			case "SharedObject.Flush.Success": 
				handleUserAction(true);
				break;
			case "SharedObject.Flush.Failed": 
				handleUserAction(false);
				break;
		}
		handleUserAction = null;
	}

}
}