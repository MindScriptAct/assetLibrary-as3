package com.mindscriptact.assetLibrary.sharedObject {
import com.mindscriptact.logmaster.DebugMan;
import flash.net.SharedObject;
import flash.utils.ByteArray;
import flash.utils.getTimer;

/**
 * ...
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class AssetLibraryStoradge {
	
	public function AssetLibraryStoradge(){
	}
	
	public function canUseStore():Boolean {
		var retVal:Boolean = false;
		var timeCheck:int = getTimer();
		var mySharedObjectIndex:SharedObject = SharedObject.getLocal("__$$_Asset_Lybrary_Index");
		mySharedObjectIndex.data.__$$_can_Use_Check = 1;
		var flushStatus:String = null;
		try {
			flushStatus = mySharedObjectIndex.flush();
			retVal = true;
		} catch (error:Error){
			//DebugMan.info("Error...Could not write SharedObject to disk, flushStatus:", flushStatus);
		}
		DebugMan.info(" !! canUseStoreCheck :" + (getTimer() - timeCheck));
		return retVal;
	}
	
	public function checkVersion(id:String, path:String):Boolean {
		var retVal:Boolean = false;
		var mySharedObjectIndex:SharedObject = SharedObject.getLocal("__$$_Asset_Lybrary_Index");

		
		return retVal;
	}
	
	public function store(id:String, path:String, byteData:ByteArray):Boolean {
		var retVal:Boolean = true;
		// Create/get a shared-objects
		var mySharedObjectIndex:SharedObject = SharedObject.getLocal("__$$_Asset_Lybrary_Index");
		var mySharedObject:SharedObject = SharedObject.getLocal(id);
		// Store data
		mySharedObject.data.byteArray = byteData;
		mySharedObjectIndex.data[id] = path;
		try {
			mySharedObject.flush();
			mySharedObjectIndex.flush();
		} catch (error:Error){
			delete mySharedObject.data.byteArray;
			delete mySharedObjectIndex.data[id];
			retVal = false;
		}
		return retVal;
	}
	
	public function get(id:String, path:String):ByteArray {
		var retVal:ByteArray;
		
		var mySharedObjectIndex:SharedObject = SharedObject.getLocal("__$$_Asset_Lybrary_Index");
		
		var mySharedObject:SharedObject = SharedObject.getLocal(id);
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

}
}