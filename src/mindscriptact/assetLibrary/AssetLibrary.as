package mindscriptact.assetLibrary {
import flash.display.*;
import flash.media.*;
import flash.net.SharedObject;
import flash.system.*;
import flash.utils.*;
import mindscriptact.assetLibrary.assets.*;
import mindscriptact.assetLibrary.core.*;
import mindscriptact.assetLibrary.core.fakeAssets.FakeAssetHelper;
import mindscriptact.assetLibrary.core.localStorage.AssetLibraryStorage;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;
import mindscriptact.assetLibrary.core.unloadHelper.AssetLibraryUnloader;

/**
 * Asset managment utility.
 * @author Raimundas Banevicius
 */
public class AssetLibrary {
	
	/**
	 * Function to handle all general errors.
	 * @private */
	static private var errorHandler:Function = throwError;
	
	/**
	 * Asset index.
	 * @private */
	static private var assetLibraryIndex:AssetLibraryIndex = new AssetLibraryIndex(errorHandler);
	
	/**
	 * Library asset loader.
	 * @private */
	static private var assetLibraryLoader:AssetLibraryLoader = new AssetLibraryLoader(assetLibraryIndex, errorHandler);
	
	/**
	 * Lybrary asset automatic usloader.
	 * @private */
	static private var assetUnloader:AssetLibraryUnloader = new AssetLibraryUnloader();
	
	/** If set to true - trying to get not permanent asset dirrectly will throw an error.
	 * @private */
	static private var canGetNonPermanentsDirectly:Boolean = true;
	
	/**
	 * If set to true - Asset lybrary will fake missing assets.
	 * @private */
	static private var _fakeMissingAssets:Boolean = false;
	
	/** Time interval for asset library to try and unload not needed assets in secconds.
	 * By default it is 0 - autounload is disabled.
	 * @private */
	static private var _autoUnloadIntervalTime:int = 0;
	
	//----------------------------------
	//     System
	//----------------------------------
	
	/**
	 * Get AssetLibraryIndex object. It is used to define your files, paths, groups.
	 * @return	AssetLibraryIndex object.
	 */
	static public function getIndex():AssetLibraryIndex {
		return assetLibraryIndex;
	}
	
	/**
	 * Get AssetLibraryLoader object. Is is used to listen for loader events. (AssetEvent and AssetLoaderEvent)
	 * @return	AssetLibraryLoader object.
	 */
	static public function getLoader():AssetLibraryLoader {
		return assetLibraryLoader;
	}
	
	//----------------------------------
	//     AssetLibrary options
	//----------------------------------
	
	/**
	 * If set to true - permament asset protection is removed. It will be possible to add permanents after initial permanent asset load and will be posible to unload permanent assets.
	 */
	static public function set isPermanentsProtected(value:Boolean):void {
		assetLibraryIndex.canAddPermanents = !value;
		assetLibraryLoader.canUnloadPermanents = !value;
	}
	
	static public function get isPermanentsProtected():Boolean {
		return !assetLibraryIndex.canAddPermanents;
	}	
	
	/**
	 * Time interval in secconds for assets to be automaticaly unloaded.
	 */
	static public function set autoUnloadIntervalTime(value:int):void {
		use namespace assetlibrary;
		if (_autoUnloadIntervalTime != value) {
			_autoUnloadIntervalTime = value;
			assetUnloader.setUnloadIntervalTime(_autoUnloadIntervalTime);
		}
	}
	
	static public function get autoUnloadIntervalTime():int {
		return _autoUnloadIntervalTime;
	}
	
	/**
	 *	Count of maximum simultaneous loadings. Default is 3. Minimum is 1.
	 */
	static public function set maxSimultaneousLoads(value:int):void {
		use namespace assetlibrary;
		if (value < 1) {
			value = 1;
		}
		assetLibraryLoader.maxSimultaneousLoads = value;
	}
	
	static public function get maxSimultaneousLoads():int {
		use namespace assetlibrary;
		return assetLibraryLoader.maxSimultaneousLoads;
	}
	
	/**
	 *	If set to true - assetLibrary will fake missing assets instead of throwing an error.
	 */
	static public function set fakeMissingAssets(value:Boolean):void {
		use namespace assetlibrary;
		assetLibraryLoader.fakeMissingAssets = value;
		_fakeMissingAssets = value;
		AssetAbstract.fakeMissingAssets = value;
	}
	
	static public function get fakeMissingAssets():Boolean {
		return _fakeMissingAssets;
	}
	
	static public function setErrorHandler(errorHandler:Function):void {
		AssetLibrary.errorHandler = errorHandler;
	}
	
	//----------------------------------
	//     General asset loading and handling with callBack function.
	//----------------------------------
	
	/**
	 * Funcion will load and send asset object to callbackFunction function.
	 * @param	assetId				assetId used to indentify asset.
	 * @param	callbackFunction	Funcion that will get asset object as parameter then it is loaded, or instantly if it is cached.
	 * @param	callBackParams		Aditional parameters that can be sent to callback function.
	 * @param	assetKeepTime		Defines how long asset must be kept in cache in secconds.
	 */
	static public function loadAsset(assetId:String, callbackFunction:Function, callBackParams:Array = null, assetKeepTime:int = int.MAX_VALUE):void {
		use namespace assetlibrary;
		if (!callBackParams) {
			callBackParams = [];
		}
		if (assetLibraryIndex.assetIsLoaded(assetId)) {
			callBackParams.unshift(assetLibraryIndex.getAsset(assetId));
			callbackFunction.apply(null, callBackParams);
		} else {
			var assetDef:AssetDefinition = assetLibraryIndex.getAssetDefinition(assetId);
			if (assetDef) {
				assetDef.callBackFunctions.push(callbackFunction);
				assetDef.callBackParams.push(callBackParams);
				assetDef.keepTime = assetKeepTime;
				assetUnloader.addAssetTime(assetId, assetKeepTime);
				assetLibraryLoader.loadAsset(assetDef);
			} else {
				errorHandler(Error("AssetLibrary.sendAssetToFunction can't find asset definition with assetId :" + assetId));
			}
			
		}
	}
	
	/**
	 * Unload asset to free used memory.
	 * @param	assetId		assetId used to indentify asset.
	 */
	static public function unloadAsset(assetId:String):void {
		var asset:AssetAbstract = assetLibraryIndex.getAsset(assetId);
		if (asset) {
			if (asset.isPermanent && !assetLibraryLoader.canUnloadPermanents) {
				errorHandler(Error("AssetLibrary.unloadAsset can't unload assetId:" + assetId + " because it is permanent asset. If you want to disable this protection: use AssetLibrary.removePermanentAssetProtection();"));
			}
			asset.unload();
		}
	}
	
	/**
	 * Unleods all non permanent assets.
	 * If permanent asset protection is removed - permanent assets unloaded too.
	 */
	static public function unloadAllAssets():void {
		use namespace assetlibrary;
		var canUnloadPermanents:Boolean = assetLibraryLoader.canUnloadPermanents;
		var assetIndex:Dictionary = assetLibraryIndex.getAssetIndex();
		for each (var assetDefinition:AssetDefinition in assetIndex) {
			if (assetDefinition.isLoaded) {
				if (assetDefinition.isPermanent) {
					if (canUnloadPermanents) {
						assetDefinition.asset.unload();
					}
				} else {
					assetDefinition.asset.unload();
				}
			}
		}
	}
	
	/**
	 * Checks if asset is loaded.
	 * @param	assetId		assetId used to indentify asset.
	 * @return		returns true if asset is already loaded.
	 */
	static public function assetIsLoaded(assetId:String):Boolean {
		return assetLibraryIndex.assetIsLoaded(assetId);
	}
	
	//----------------------------------
	//     Dynamic asset loading
	//----------------------------------
	
	/**
	 * Function to load asset dynamicaly. Asset does not need to be defined. pothId - must be defined and it must have 'dynamicPathAssetType' set. All suported types are in AssetType class.
	 * @param	pathId				path id for defined path for dinamyc files, this path MUST have 'dynamicPathAssetType' set. All suported types are in AssetType class.
	 * @param	assetId				assetId used to indentify asset.
	 * @param	callbackFunction	Funcion that will get asset object as parameter then it is loaded, or instantly if it is cached.
	 * @param	callBackParams		Aditional parameters that can be sent to callback function.
	 * @param	assetKeepTime		Defines how long asset must be kept in cache in secconds.
	 * @param	fileName			If fileName is not provided -  assetId is used as filename. Best practice is to keep assetId the same as fileName, but if it can't be done you have to provide actial fileName.
	 */
	static public function loadDynamicAsset(pathId:String, assetId:String, callbackFunction:Function, callBackParams:Array = null, assetKeepTime:int = int.MAX_VALUE, fileName:String = null):void {
		use namespace assetlibrary;
		
		// check if path is dynamic.
		var assetType:String = assetLibraryIndex.getPathType(pathId);
		if (!assetType) {
			errorHandler(Error("AssetLibrary.loadDynamicAsset can load only files from paths that have 'dynamicPathAssetType' parameter set with assetIndex.addPathDefinition() function. Failed with assetId :" + assetId));
		}
		
		if (!fileName) {
			fileName = assetId;
		}
		
		// check if definition exists, if not - created it.
		var assetDefinition:AssetDefinition = assetLibraryIndex.getAssetDefinition(assetId);
		if (!assetDefinition) {
			assetLibraryIndex.addFileDefinition(assetId, fileName + "." + assetType, pathId);
		}
		
		// load asset normaly
		loadAsset(assetId, callbackFunction, callBackParams, assetKeepTime);
	
	}
	
	//----------------------------------
	//     group handling
	//----------------------------------
	
	static public function loadGroupAssets(groupId:String):void {
		var assetIds:Vector.<String> = assetLibraryIndex.getGroupAssets(groupId);
		for (var i:int = 0; i < assetIds.length; i++) {
			AssetLibrary.loadAsset(assetIds[i], handleAssetBlank);
		}
	}
	
	static public function unloadGroupAssets(groupId:String):void {
		var assetIds:Vector.<String> = assetLibraryIndex.getGroupAssets(groupId);
		for (var i:int = 0; i < assetIds.length; i++) {
			AssetLibrary.unloadAsset(assetIds[i]);
		}
	}
	
	//----------------------------------
	//     Local Storage controls
	//----------------------------------
	
		/**
	 * Enables use of local storage to cash loaded assets.
	 * @param	projectId	Unique project id. Project web url or project name should work just fine.
	 */
	static public function enableLocalStorage(projectId:String):void {
		assetLibraryLoader.enableLocalStorage(projectId);
	}
	
	/**
	 * Disable use of local storage to cash loaded assets.
	 */	
	static public function disableLocalStorage():void {
		assetLibraryLoader.disableLocalStorage();
	}
	
	/**
	 * Clears assetLebrary sharecd storage. If projectId is not provided - it will try to clear local storage in current use.
	 * @param	projectId	Optional projectId if you want to clear another project assetLibrary shared storage, or shared storage is not enabled yet.
	 */
	static public function clearStorage(projectId:String = null):void {
		assetLibraryLoader.clearLocalStorage(projectId);
	}
	
	static public function setLocalStorageFailHandler(handleStorageFail:Function):void {
		assetLibraryLoader.handleStorageFail = handleStorageFail;
	}
	
	static public function openStorageSettings():void {
		Security.showSettings(SecurityPanel.LOCAL_STORAGE);
	}
	
	static public function requestStorageSpace(handleUserAction:Function, size:int = 11):Boolean {
		// TODO : implement.
		return false;
	}
	
	//
	//private function handleUserAction(isAllowed:Boolean):void {
	//
	//}
	
	//--------------------------------------------------------------------------
	//
	//      Permanent asset getters
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//     SWF asset getters
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
	
	/** General function to get SWF asset stuff.
	 * @private */
	static private function getSWFStuff(assetId:String, lincageId:String, type:String):Object {
		var asset:SwfAsset = assetLibraryIndex.getAsset(assetId) as SwfAsset;
		if (!asset) {
			errorHandler(Error("AssetLibrary can't find SWF asset with assetId :" + assetId));
		} else {
			if (canGetNonPermanentsDirectly && !asset.isPermanent) {
				errorHandler(Error("AssetLibrary can't directly use SWF asset with assetId:" + assetId + ". Only permanent assets can be used that way. Use AssetLibrary.sendAssetToFunction(" + assetId + ", myHandleAssetFunction); instead."));
			} else {
				try {
					switch (type) {
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
				} catch (error:Error) {
					if (_fakeMissingAssets) {
						switch (type) {
							case "STAGE": 
								return FakeAssetHelper.fakeMovieClip(assetId + "\n" + lincageId + "\n" + type);
								break;
							case "MC": 
								return FakeAssetHelper.fakeMovieClip(assetId + "\n" + lincageId + "\n" + type);
								break;
							case "SPR": 
								return FakeAssetHelper.fakeSprite(assetId + "\n" + lincageId + "\n" + type);
								break;
							case "BTN": 
								return FakeAssetHelper.fakeButton(assetId + "\n" + lincageId + "\n" + type);
								break;
							case "BD": 
								return FakeAssetHelper.fakeBitmapData(assetId + "\n" + lincageId + "\n" + type);
								break;
							case "SND": 
								return FakeAssetHelper.fakeSound();
								break;
							default: 
								trace("not handled case : ", type);
								break;
						}
					} else {
						errorHandler(error);
					}
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
		var asset:PicAsset = assetLibraryIndex.getAsset(assetId) as PicAsset;
		if (!asset) {
			errorHandler(Error("AssetLibrary can't find PIC asset with assetId :" + assetId));
		} else {
			if (canGetNonPermanentsDirectly && !asset.isPermanent) {
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
		var asset:PicAsset = assetLibraryIndex.getAsset(assetId) as PicAsset;
		if (!asset) {
			errorHandler(Error("AssetLibrary can't find PIC asset with assetId :" + assetId));
		} else {
			if (canGetNonPermanentsDirectly && !asset.isPermanent) {
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
		var asset:Mp3Asset = assetLibraryIndex.getAsset(assetId) as Mp3Asset;
		if (!asset) {
			errorHandler(Error("AssetLibrary can't find MP3 asset with assetId :" + assetId));
		} else {
			if (canGetNonPermanentsDirectly && !asset.isPermanent) {
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
	 * @param	loops	Defines the number of times a sound loops back to the startTime value before the sound channel stops playback.
	 * @param	sndTransform	The initial SoundTransform object assigned to the sound channel.
	 */
	static public function playMP3(assetId:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void {
		var asset:Mp3Asset = assetLibraryIndex.getAsset(assetId) as Mp3Asset;
		if (!asset) {
			errorHandler(Error("AssetLibrary can't find MP3 asset with assetId :" + assetId));
		} else {
			if (canGetNonPermanentsDirectly && !asset.isPermanent) {
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
		var asset:Mp3Asset = assetLibraryIndex.getAsset(assetId) as Mp3Asset;
		if (!asset) {
			errorHandler(Error("AssetLibrary can't find MP3 asset with assetId :" + assetId));
		} else {
			if (canGetNonPermanentsDirectly && !asset.isPermanent) {
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
		var soundAssets:Vector.<Mp3Asset> = assetLibraryIndex.getAllSoundAssets();
		for (var i:int = 0; i < soundAssets.length; i++) {
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
	 * @param	loops	Defines the number of times a sound loops back to the startTime value before the sound channel stops playback.
	 * @param	sndTransform	The initial SoundTransform object assigned to the sound channel.
	 */
	static public function playMP3NowOrNever(assetId:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void {
		var asset:Mp3Asset = assetLibraryIndex.getAsset(assetId) as Mp3Asset;
		if (!asset) {
			errorHandler(Error("AssetLibrary can't find MP3 asset with assetId :" + assetId));
		} else {
			if (asset.isLoaded) {
				asset.play(startTime, loops, sndTransform);
			} else {
				loadAsset(assetId, handleAssetBlank);
			}
		}
	}
	
	/**
	 * Plays sound located in swf asset, and linked as a sound.
	 * @param	assetId		Id of asset in assetIndex
	 * @param	lincageId	object lincage id in swf file library
	 * @param	startTime	The initial position in milliseconds at which playback should start.
	 * @param	loops	Defines the number of times a sound loops back to the startTime value before the sound channel stops playback.
	 * @param	sndTransform	The initial SoundTransform object assigned to the sound channel.
	 */
	static public function playSwfSound(assetId:String, lincageId:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void {
		var sound:Sound = getSWFSound(assetId, lincageId);
		sound.play(startTime, loops, sndTransform);
	}
	
	static public function stopSwfSoundChannels(assetId:String, lincageId:String):void {
		// TODO : implement
	}
	
	/**
	 * Plays sound  located in swf asset, and linked as a sound if it is currently loaded. If not - it will not play the sound - but it will loand the asset for next use.
	 * @param	assetId		Id of asset in assetIndex
	 * @param	lincageId	object lincage id in swf file library
	 * @param	startTime	The initial position in milliseconds at which playback should start.
	 * @param	loops	Defines the number of times a sound loops back to the startTime value before the sound channel stops playback.
	 * @param	sndTransform	The initial SoundTransform object assigned to the sound channel.
	 */
	static public function playSwfSoundNowOrNever(assetId:String, lincageId:String, startTime:Number = 0, loops:int = 0, sndTransform:SoundTransform = null):void {
		var asset:SwfAsset = assetLibraryIndex.getAsset(assetId) as SwfAsset;
		if (!asset) {
			errorHandler(Error("AssetLibrary can't find SWF asset with assetId :" + assetId));
		} else {
			if (asset.isLoaded) {
				playSwfSound(assetId, lincageId, startTime, loops, sndTransform);
			} else {
				loadAsset(assetId, handleAssetBlank);
			}
		}
	}
	
	//----------------------------------
	//     INTERNAL
	//----------------------------------
	
	static private function throwError(error:Error):void {
		throw error;
	}
	
	static private function handleAssetBlank(asset:AssetAbstract):void {
	}

}
}