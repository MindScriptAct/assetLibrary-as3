package com.mindscriptact.assetLibrary {
import com.mindscriptact.assetLibrary.AssetDefinition;
import com.mindscriptact.assetLibrary.assets.MP3Asset;
import com.mindscriptact.assetLibrary.assets.PICAsset;
import com.mindscriptact.assetLibrary.assets.SWFAsset;
import com.mindscriptact.assetLibrary.namespaces.assetlibrary;
import com.mindscriptact.assetLibrary.sharedObject.AssetLibraryStoradge;
import com.mindscriptact.assetLibrary.unloadHelper.UnloadHelper;
import com.mindscriptact.logmaster.DebugMan;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.media.Sound;
import flash.media.SoundTransform;
import flash.system.Security;
import flash.system.SecurityPanel;
import flash.utils.Dictionary;

/**
 * Quick and dirty asset library.
 * @author Raimundas Banevicius
 */
public class AssetLibrary {
	//
	// permanent assets is the only asset type, there you can get assets without callback.
	// protected assets can't be unloaded.
	static public var restrictAccsessToNonPermanents:Boolean = true;
	
	//
	static private var _autoUnloadIntervalTime:int;
	//
	static private var assetLibraryIndex:AssetLibraryIndex;
	static private var assetLibraryLoader:AssetLibraryLoader;
	static private var localStoradge:AssetLibraryStoradge;
	static private var unloadHelper:UnloadHelper;
	static private var isInitted:Boolean;
	
	static private var errorHandler:Function = throwError;
	
	static private function init():void {
		isInitted = true;
		localStoradge = new AssetLibraryStoradge();
		assetLibraryIndex = new AssetLibraryIndex(errorHandler);
		assetLibraryLoader = new AssetLibraryLoader(assetLibraryIndex, localStoradge, errorHandler);
		unloadHelper = new UnloadHelper();
		autoUnloadIntervalTime = 10;
		maxSimultaneousLoads = 3;
	}
	
	//----------------------------------
	//     System
	//----------------------------------
	
	static public function loadList(list:Vector.<AssetDefinition>):void {
		use namespace assetlibrary;
		if (!isInitted){
			init();
		}
		for (var i:int = 0; i < list.length; i++){
			var item:AssetDefinition = list[i];
			if (item.isPermanent){
				assetLibraryLoader.loadAsset(item);
			}
		}
	}
	
	static public function getLoader():AssetLibraryLoader {
		if (!isInitted){
			init();
		}
		return assetLibraryLoader;
	}
	
	static public function getIndex():AssetLibraryIndex {
		if (!isInitted){
			init();
		}
		return assetLibraryIndex;
	}
	
	////////////
	
	static public function removePermanentAssetProtection():void {
		assetLibraryIndex.canAddPermanents = true;
		assetLibraryLoader.isPermanentsProtected = false;
	}
	
	static public function unloadAsset(assetId:String):void {
		var asset:AssetAbstract = assetLibraryIndex.getAsset(assetId);
		if (asset){
			if (asset.isPermanent && assetLibraryLoader.isPermanentsProtected){
				errorHandler(Error("AssetLibrary.unloadAsset can't unload assetId:" + assetId + " because it is permanent asset. If you want to disable this protection: use AssetLibrary.removePermanentAssetProtection();"));
			}
			asset.unload();
		}
	}
	
	static private function throwError(error:Error):void {
		throw error;
	}
	
	static public function loadGroupAssets(groupId:String):void {
		DebugMan.info("AssetLibraryIndex.loadGroupAssets > groupId : " + groupId);
		var assetIds:Vector.<String> = assetLibraryIndex.getGroupAssets(groupId);
		for (var i:int = 0; i < assetIds.length; i++){
			AssetLibrary.sendAssetToFunction(assetIds[i], handleAssetBlank);
		}
	}
	
	static private function handleAssetBlank(asset:AssetAbstract):void {
		DebugMan.info("AssetLibrary.handleAssetBlank > asset : " + asset.assetId);
	}
	
	static public function unloadGroupAssets(groupId:String):void {
		DebugMan.info("AssetLibraryIndex.unloadGroupAssets > groupId : " + groupId);
		var assetIds:Vector.<String> = assetLibraryIndex.getGroupAssets(groupId);
		for (var i:int = 0; i < assetIds.length; i++){
			AssetLibrary.unloadAsset(assetIds[i]);
		}
	}
	
	static public function unloadAllNonPermanents():void {
		use namespace assetlibrary;
		var assetIndex:Dictionary = assetLibraryIndex.assetIndex;
		for each (var assetDefinition:AssetDefinition in assetIndex){
			if (!assetDefinition.isPermanent && assetDefinition.isLoaded){
				assetDefinition.asset.unload();
			}
		}
	}
	
	static public function setRootPath(rootPath:String):void {
		use namespace assetlibrary;
		if (!isInitted){
			init();
		}
		assetLibraryLoader.rootPath = rootPath;
	}
	
	//----------------------------------
	//     auto unload handlisg
	//----------------------------------
	
	static public function get autoUnloadIntervalTime():int {
		return _autoUnloadIntervalTime;
	}
	
	static public function set autoUnloadIntervalTime(value:int):void {
		use namespace assetlibrary;
		if (_autoUnloadIntervalTime != value) {
			_autoUnloadIntervalTime = value;
			unloadHelper.setUnloadIntervalTime(_autoUnloadIntervalTime);
		}
	}
	
	//----------------------------------
	//     Local storadge controls
	//----------------------------------
	
	static public function set localStoradgeEnabled(value:Boolean):void {
		use namespace assetlibrary;
		if (!isInitted){
			init();
		}
		assetLibraryLoader._localStoradgeEnabled = value;
	}
	
	static public function get localStoradgeEnabled():Boolean {
		use namespace assetlibrary;
		if (!isInitted){
			init();
		}
		return assetLibraryLoader._localStoradgeEnabled;
	}
	
	static public function clearLocalStoradge():void {
		// TODO : implement.
	}
	
	static public function setStoradgeFailHandler(handleStoradgeFail:Function):void {
		assetLibraryLoader.handleStoradgeFail = handleStoradgeFail
	}
	
	static public function forseOpenLocalStorageSettings():void {
		Security.showSettings(SecurityPanel.LOCAL_STORAGE);
	}
	
	//----------------------------------
	//     
	//----------------------------------
	
	static public function get maxSimultaneousLoads():int {
		use namespace assetlibrary;
		if (!isInitted){
			init();
		}
		return assetLibraryLoader.maxSimultaneousLoads;
	}
	
	static public function set maxSimultaneousLoads(value:int):void {
		use namespace assetlibrary;
		if (!isInitted){
			init();
		}
		if (value < 1){
			value = 1;
		}
		assetLibraryLoader.maxSimultaneousLoads = value;
	}
	
	//----------------------------------
	//     General asset getter
	//----------------------------------
	
	static public function sendAssetToFunction(assetId:String, callbackFunction:Function, callBackParams:Array = null, assetKeepTime:int = int.MAX_VALUE):void {
		use namespace assetlibrary;
		if (!callBackParams){
			callBackParams = [];
		}
		if (assetLibraryIndex.assetIsLoaded(assetId)){
			callBackParams.unshift(assetLibraryIndex.getAsset(assetId));
			callbackFunction.apply(null, callBackParams);
		} else {
			var assetDef:AssetDefinition = assetLibraryIndex.getAssetDefinition(assetId);
			if (assetDef){
				assetDef.callBackFunctions.push(callbackFunction);
				assetDef.callBackParams.push(callBackParams);
				assetDef.keepTime = assetKeepTime;
				unloadHelper.addAssetTime(assetId, assetKeepTime);
				assetLibraryLoader.loadAsset(assetDef);
			} else {
				errorHandler(Error("AssetLibrary.sendAssetToFunction can't find asset definition with assetId :" + assetId));
			}
			
		}
	}
	
	//----------------------------------
	//     SWF asset getter
	//----------------------------------
	
	/**
	 * Gives instance of SWF file stage.
	 * Only pernament assets can be used this way. (For not pernament once use AssetLibrary.sendAssetToFunction(...));
	 * It can be used only once(this function does not create instance of the stage, it gives stage itself.)
	 * If you need to use it twice - create MovieClip object in library instead.
	 * @param	assetId		Id of asset in assetIndex
	 * @return	Content of swf file stage.
	 */
	static public function getSWFStageContent(assetId:String):MovieClip {
		return AssetLibrary.getSWFStuff(assetId, "", "STAGE") as MovieClip;
	}
	
	/**
	 * Gives instance of MovieClip object from SWF file library
	 * Only pernament assets can be used this way. (For not pernament once use AssetLibrary.sendAssetToFunction(...));
	 * @param	assetId		Id of asset in assetIndex
	 * @param	lincageId	object lincage id in swf file library
	 * @return	instance of MovieClip taken from asset library, using lincageId
	 */
	static public function getSWFMovieClip(assetId:String, lincageId:String):MovieClip {
		return AssetLibrary.getSWFStuff(assetId, lincageId, "MC") as MovieClip;
	}
	
	/**
	 * Gives instance of Sprite object from SWF file library
	 * Only pernament assets can be used this way. (For not pernament once use AssetLibrary.sendAssetToFunction(...));
	 * @param	assetId		Id of asset in assetIndex
	 * @param	lincageId	object lincage id in swf file library
	 * @return	instance of Sprite taken from asset library, using lincageId
	 */
	static public function getSWFSprite(assetId:String, lincageId:String):Sprite {
		return AssetLibrary.getSWFStuff(assetId, lincageId, "SPR") as Sprite;
	}
	
	/**
	 * Gives instance of SimpleButton object from SWF file library
	 * Only pernament assets can be used this way. (For not pernament once use AssetLibrary.sendAssetToFunction(...));
	 * @param	assetId		Id of asset in assetIndex
	 * @param	lincageId	object lincage id in swf file library
	 * @return	instance of SimpleButton taken from asset library, using lincageId
	 */
	static public function getSWFSimpleButton(assetId:String, lincageId:String):SimpleButton {
		return AssetLibrary.getSWFStuff(assetId, lincageId, "BTN") as SimpleButton;
	}
	
	/**
	 * Gives instance of BitmapData object from SWF file library
	 * Only pernament assets can be used this way. (For not pernament once use AssetLibrary.sendAssetToFunction(...));
	 * @param	assetId		Id of asset in assetIndex
	 * @param	lincageId	object lincage id in swf file library
	 * @return	instance of BitmapData taken from asset library, using lincageId
	 */
	static public function getSWFBitmapData(assetId:String, lincageId:String):BitmapData {
		return AssetLibrary.getSWFStuff(assetId, lincageId, "BD") as BitmapData;
	}
	
	/**
	 * Gives instance of Sound object from SWF file library
	 * Only pernament assets can be used this way. (For not pernament once use AssetLibrary.sendAssetToFunction(...));
	 * @param	assetId		Id of asset in assetIndex
	 * @param	lincageId	object lincage id in swf file library
	 * @return	instance of Sound taken from asset library, using lincageId
	 */
	static public function getSWFSound(assetId:String, lincageId:String):Sound {
		return AssetLibrary.getSWFStuff(assetId, lincageId, "SND") as Sound;
	}
	
	/* General function to get SWF asset stuff. */
	static private function getSWFStuff(assetId:String, lincageId:String, type:String):Object {
		var asset:SWFAsset = assetLibraryIndex.getAsset(assetId) as SWFAsset;
		if (!asset){
			errorHandler(Error("AssetLibrary can't find SWF asset with assetId :" + assetId));
		} else {
			if (restrictAccsessToNonPermanents && !asset.isPermanent){
				errorHandler(Error("AssetLibrary can't directly use SWF asset with assetId:" + assetId + ". Only permanent assets can be used that way. Use AssetLibrary.sendAssetToFunction(" + assetId + ", myHandleAssetFunction); instead."));
			} else {
				try {
					switch (type){
						case "STAGE": 
							return asset.getStageContent();
							break;
						case "MC": 
							return asset.getMovieClip(lincageId);
							break;
						case "SPR": 
							return asset.getSprite(lincageId);
							break;
						case "BTN": 
							return asset.getSimpleButton(lincageId);
							break;
						case "BD": 
							return asset.getBitmapData(lincageId);
							break;
						case "SND": 
							return asset.getSound(lincageId);
							break;
						default: 
							trace("not handled case : ", type);
							break;
					}
				} catch (error:Error){
					errorHandler(error);
				}
			}
		}
		return null;
	}
	
	//----------------------------------
	//     PIC asset getter
	//----------------------------------
	
	/**
	 * Gives PIC asset Bitmap instance with loaded BitmapData content.
	 * This metod does not clone pictures BitmapData, that means it will not use extra memory to show extra copies.
	 * If you modify it's content - all other not cloned instances of same Pic will be modified with it,
	 *   and all new cloned instances will clone those changes.
	 * Only pernament assets can be used this way. (For not pernament once use AssetLibrary.sendAssetToFunction(...));
	 * @param	assetId		Id of asset in assetIndex
	 * @return	Bitmap instance with picture of PIC asset
	 */
	static public function getPICBitmap(assetId:String):Bitmap {
		var asset:PICAsset = assetLibraryIndex.getAsset(assetId) as PICAsset;
		if (!asset){
			errorHandler(Error("AssetLibrary can't find PIC asset with assetId :" + assetId));
		} else {
			if (restrictAccsessToNonPermanents && !asset.isPermanent){
				errorHandler(Error("AssetLibrary can't directly use PIC asset with assetId:" + assetId + ". Only permanent assets can be used that way. Use AssetLibrary.sendAssetToFunction(" + assetId + ", myHandleAssetFunction); instead."));
			} else {
				return asset.getBitmap();
			}
		}
		return null;
	}
	
	/**
	 * Gives PIC asset Bitmap instance with loaded BitmapData content.
	 * This method will create a clone of picture.
	 * It's possible to modify it without modifiing original loaded picture.
	 * Only pernament assets can be used this way. (For not pernament once use AssetLibrary.sendAssetToFunction(...));
	 * @param	assetId		Id of asset in assetIndex
	 * @return	Bitmap instance with picture of PIC asset
	 */
	static public function getPICClonedBitmap(assetId:String):Bitmap {
		var asset:PICAsset = assetLibraryIndex.getAsset(assetId) as PICAsset;
		if (!asset){
			errorHandler(Error("AssetLibrary can't find PIC asset with assetId :" + assetId));
		} else {
			if (restrictAccsessToNonPermanents && !asset.isPermanent){
				errorHandler(Error("AssetLibrary can't directly use PIC asset with assetId:" + assetId + ". Only permanent assets can be used that way. Use AssetLibrary.sendAssetToFunction(" + assetId + ", myHandleAssetFunction); instead."));
			} else {
				return asset.getClonedBitmap();
			}
		}
		return null;
	}
	
	//----------------------------------
	//     MP3 asset getter
	//----------------------------------
	
	/**
	 * Gives Sound object of loadede .mp3 file asset.
	 * @param	assetId		Id of asset in assetIndex
	 * @return	Sound instance
	 */
	static public function getMP3Sound(assetId:String):Sound {
		var asset:MP3Asset = assetLibraryIndex.getAsset(assetId) as MP3Asset;
		if (!asset){
			errorHandler(Error("AssetLibrary can't find MP3 asset with assetId :" + assetId));
		} else {
			if (restrictAccsessToNonPermanents && !asset.isPermanent){
				errorHandler(Error("AssetLibrary can't directly use MP3 asset with assetId:" + assetId + ". Only permanent assets can be used that way. Use AssetLibrary.sendAssetToFunction(" + assetId + ", myHandleAssetFunction); instead."));
			} else {
				return asset.getSound();
			}
		}
		return null;
	}
	
	//----------------------------------
	//     MP3 sound managment
	//----------------------------------	
	
	/**
	 * Starts standart mp3 asset playBack.
	 * The only thing you can do if you use this method after its started : use stopAllMP3Channels() to stop all sounds of this asset
	 *   or stopAllMP3Sounds() to stop all sound.
	 * If you need more controll over how you want to use sound = use getMP3Sound() instead.
	 * @param	assetId		Id of asset in assetIndex
	 * @param	startTime	The initial position in milliseconds at which playback should start.
	 * @param	loops	Defines the number of times a sound loops back to the startTime value
	 * before the sound channel stops playback.
	 * @param	sndTransform	The initial SoundTransform object assigned to the sound channel.
	 */
	static public function playMP3(assetId:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void {
		var asset:MP3Asset = assetLibraryIndex.getAsset(assetId) as MP3Asset;
		if (!asset){
			errorHandler(Error("AssetLibrary can't find MP3 asset with assetId :" + assetId));
		} else {
			if (restrictAccsessToNonPermanents && !asset.isPermanent){
				errorHandler(Error("AssetLibrary can't directly use MP3 asset with assetId:" + assetId + ". Only permanent assets can be used that way. Use AssetLibrary.sendAssetToFunction(" + assetId + ", myHandleAssetFunction); instead."));
			} else {
				asset.play(startTime, loops, sndTransform);
			}
		}
	}
	
	/**
	 * Stops all started channels for specidied sound.
	 * Only channels started with AssetLibrary can be stoped this way.
	 * @param	assetId		Id of asset in assetIndex
	 */
	static public function stopMP3Channels(assetId:String):void {
		var asset:MP3Asset = assetLibraryIndex.getAsset(assetId) as MP3Asset;
		if (!asset){
			errorHandler(Error("AssetLibrary can't find MP3 asset with assetId :" + assetId));
		} else {
			if (restrictAccsessToNonPermanents && !asset.isPermanent){
				errorHandler(Error("AssetLibrary can't directly use MP3 asset with assetId:" + assetId + ". Only permanent assets can be used that way. Use AssetLibrary.sendAssetToFunction(" + assetId + ", myHandleAssetFunction); instead."));
			} else {
				asset.stopAllChannels();
			}
		}
	}
	
	/**
	 * Stops all started sounds.
	 * Only sounds started with AssetLibrary can be stoped this way.
	 */
	static public function stopAllMP3Sounds():void {
		var soundAssets:Vector.<MP3Asset> = assetLibraryIndex.getAllSoundAssets();
		for (var i:int = 0; i < soundAssets.length; i++){
			soundAssets[i].stopAllChannels();
		}
	}
	
	/**
	 * Starts standart mp3 asset playBack, for pernament or temporary file.
	 * If file is loaded, sound is started.
	 * If file is not loaded it is loadod, but not played.
	 * The only thing you can do if you use this method after its started : use stopAllMP3Channels() to stop all sounds of this asset
	 *   or stopAllMP3Sounds() to stop all sound.
	 * If you need more controll over how you want to use sound = use getMP3Sound() instead.
	 * @param	assetId		Id of asset in assetIndex
	 * @param	startTime	The initial position in milliseconds at which playback should start.
	 * @param	loops	Defines the number of times a sound loops back to the startTime value
	 * before the sound channel stops playback.
	 * @param	sndTransform	The initial SoundTransform object assigned to the sound channel.
	 */
	static public function playMP3NowOrNever(assetId:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void {
		var asset:MP3Asset = assetLibraryIndex.getAsset(assetId) as MP3Asset;
		if (!asset){
			errorHandler(Error("AssetLibrary can't find MP3 asset with assetId :" + assetId));
		} else {
			if (asset.isLoaded){
				asset.play(startTime, loops, sndTransform);
			} else {
				sendAssetToFunction(assetId, handleAssetBlank);
			}
		}
	}

}
}