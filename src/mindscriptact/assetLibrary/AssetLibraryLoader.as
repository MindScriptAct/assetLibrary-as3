package mindscriptact.assetLibrary {
import flash.events.EventDispatcher;
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import mindscriptact.assetLibrary.assets.XmlAsset;
import mindscriptact.assetLibrary.core.AssetDefinition;
import mindscriptact.assetLibrary.core.AssetType;
import mindscriptact.assetLibrary.core.loader.AssetLoadWorker;
import mindscriptact.assetLibrary.core.localStorage.AssetLibraryStorage;
import mindscriptact.assetLibrary.core.xml.AssetXmlParser;
import mindscriptact.assetLibrary.events.AssetEvent;
import mindscriptact.assetLibrary.events.AssetLoaderEvent;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;

[Event(name="assetXmlLoadingStarted",type="mindscriptact.assetLibrary.events.AssetLoaderEvent")]
[Event(name="assetXmlLoaded",type="mindscriptact.assetLibrary.events.AssetLoaderEvent")]
[Event(name="allPermanentAssetsLoaded",type="mindscriptact.assetLibrary.events.AssetLoaderEvent")]

[Event(name="assetLoadingStarted",type="mindscriptact.assetLibrary.events.AssetEvent")]
[Event(name="assetLoaded",type="mindscriptact.assetLibrary.events.AssetEvent")]
[Event(name="assetLoadProgress",type="mindscriptact.assetLibrary.events.AssetEvent")]

/**
 * COMMENT
 * @author Raimundas Banevicius
 */
public class AssetLibraryLoader extends EventDispatcher {
	
	private var assetLibraryIndex:AssetLibraryIndex;
	
	internal var storageManager:AssetLibraryStorage;
	//
	private var assetLoadWorker:AssetLoadWorker;
	//
	private var xmlAssetParser:AssetXmlParser;
	//
	private var filesQueue:Vector.<AssetDefinition> = new Vector.<AssetDefinition>();
	//
	private var _isLoading:Boolean = false;
	private var isPreloading:Boolean = false;
	private var isPreloadingXMLs:Boolean = false;
	private var needsPreloading:Boolean = false;
	//
	public var canUnloadPermanents:Boolean = false;
	
	internal var handleStorageFail:Function = internalHandleStorageFail;
	
	private var useLocalStorage:Boolean = false;
	
	private var _fakeMissingAssets:Boolean = false;
	//
	private var errorHandler:Function;
	
	//
	static assetlibrary var rootPath:String = "";
	//
	//public var testTime:int;
	assetlibrary var maxSimultaneousLoads:int = 3;
	//
	//
	assetlibrary var lodedFiles:int = 0;
	assetlibrary var totalFiles:int = 0;
	//
	assetlibrary var lodedXMLFiles:int = 0;
	assetlibrary var totalXMLFiles:int = 0;
	
	//
	public function AssetLibraryLoader(assetLibraryIndex:AssetLibraryIndex, errorHandler:Function) {
		this.assetLibraryIndex = assetLibraryIndex;
		this.assetLibraryIndex.libraryLaderLoadXmlFunction = handleXmlLoadStart;
		//
		this.errorHandler = errorHandler;
		//
		xmlAssetParser = new AssetXmlParser(assetLibraryIndex);
		assetLoadWorker = new AssetLoadWorker(this);
	
	}
	
	public function preloadPermanents():void {
		if (!isPreloadingXMLs) {
			var filesForPreloading:Vector.<AssetDefinition> = assetLibraryIndex.getAssetsForPreloading();
			for (var i:int = 0; i < filesForPreloading.length; i++) {
				loadAsset(filesForPreloading[i]);
			}
			if (filesForPreloading.length > 0) {
				isPreloading = true;
			} else {
				endPermanentsPreload();
			}
		} else {
			needsPreloading = true;
		}
	}
	
	public function get isLoading():Boolean {
		return _isLoading;
	}
	
	//----------------------------------
	//     INTERNAL
	//----------------------------------
	
	internal function enableLocalStorage(projectId:String):void {
		if (!projectId) {
			errorHandler(new Error("To enable Flash local storage you must provide projectid. Project web url or project name should work just fine."));
		}
		useLocalStorage = true;
		storageManager = new AssetLibraryStorage(projectId, errorHandler);
	
	}
	
	internal function disableLocalStorage():void {
		useLocalStorage = false;
		storageManager = null;
	}
	
	internal function loadAsset(item:AssetDefinition):void {
		use namespace assetlibrary;
		filesQueue.push(item);
		//
		this.totalFiles++;
		
		if (!_isLoading) {
			loadNextFile();
		}
		
		if (isPreloadingXMLs) {
			dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.XML_LOADING_STARTED, item.assetId, this.lodedFiles, this.totalFiles, assetLoadWorker.filesInProgress, assetLoadWorker.getProgress()));
		} else {
			dispatchEvent(new AssetEvent(AssetEvent.ASSET_LOADING_STARTED, item.assetId, this.lodedFiles, this.totalFiles, assetLoadWorker.filesInProgress, assetLoadWorker.getProgress()));
		}
	}
	
	private function loadNextFile():void {
		use namespace assetlibrary;
		if (filesQueue.length) {
			_isLoading = true;
			var loadItem:AssetDefinition = filesQueue.shift();
			switch (loadItem.type) {
				case AssetType.SWF: 
				case AssetType.JPG: 
				case AssetType.PNG: 
				case AssetType.GIF: 
					var loadNarmaly:Boolean = true;
					if (useLocalStorage) {
						if (storageManager.canUseStore()) {
							loadNarmaly = false;
						} else {
							handleStorageFail();
						}
					}
					if (loadNarmaly) {
						assetLoadWorker.loadNormally(loadItem);
					} else {
						//testTime = getTimer();
						var binary:ByteArray = storageManager.get(loadItem.assetId, loadItem.filePath);
						//testTime = getTimer();
						if (binary) {
							assetLoadWorker.loadStorageBytes(loadItem, binary);
						} else {
							assetLoadWorker.loadBinary(loadItem);
						}
					}
					break;
				case AssetType.XML: 
					assetLoadWorker.loadText(loadItem);
					break;
				case AssetType.MP3: 
					assetLoadWorker.loadSound(loadItem);
					break;
				default: 
					trace("WARNING : type is not handled.", loadItem.type);
					break;
			}
			// start simultaneous loads if able.
			if (filesQueue.length && assetLoadWorker.filesInProgress < maxSimultaneousLoads) {
				loadNextFile();
			}
		} else {
			if (!assetLoadWorker.filesInProgress) {
				_isLoading = false;
				if (isPreloading) {
					isPreloading = false;
					endPermanentsPreload();
				}
				resetFileCounters();
			}
		}
	}
	
	private function endPermanentsPreload():void {
		use namespace assetlibrary;
		if (!canUnloadPermanents) {
			assetLibraryIndex.canAddPermanents = false;
		}
		dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.ALL_PERMANENTS_LOADED, "", this.lodedFiles, this.totalFiles, assetLoadWorker.filesInProgress, assetLoadWorker.getProgress()));
	}
	
	private function resetFileCounters():void {
		use namespace assetlibrary;
		this.lodedFiles = 0;
		this.totalFiles = 0;
	}
	
	internal function set fakeMissingAssets(value:Boolean):void {
		use namespace assetlibrary;
		_fakeMissingAssets = value;
		assetLoadWorker.fakeMissingAssets = value;
	}
	
	private function handleXmlLoadStart(assetDefinition:AssetDefinition):void {
		//trace("AssetLibraryLoader.handleXmlLoadStart > event : " + event.assetDefinition.assetId);
		isPreloadingXMLs = true;
		loadAsset(assetDefinition);
	}
	
	private function internalHandleStorageFail():void {
		errorHandler(Error("AssitLibrary failed to store data localy(Maybe it is disabled)"));
	}
	
	internal function clearLocalStorage(projectId:String):void {
		if (storageManager) {
			use namespace assetlibrary;
			if (!projectId) {
				projectId = AssetLibraryStorage.getProjectId();
			}
			var assetIndex:Dictionary = assetLibraryIndex.getAssetIndex();
			for each (var asset:AssetDefinition in assetIndex) {
				AssetLibraryStorage.clearSharedObject(projectId + "_" + asset.assetId);
			}
		} else {
			errorHandler(Error("Local storage is not enabled. If you want to clear not enabled storage please provide 'projectId'."));
		}
	}
	
	//----------------------------------
	//     loaded content handling. (invoked by AssetLoaderWorker)
	//----------------------------------
	
	assetlibrary function handleBinaryDataLoad(asssetDefinition:AssetDefinition, data:ByteArray):void {
		use namespace assetlibrary;
		//trace(" @@ binary file loaded:", getTimer() - testTime);
		//testTime = getTimer();
		//
		if (!storageManager.store(asssetDefinition.assetId, asssetDefinition.filePath, data)) {
			errorHandler(Error("Storing assit to local SharedObject failed." + " [assetId:" + asssetDefinition.assetId + "] [assetPath:" + asssetDefinition.filePath + "]"));
		}
		//trace(" << binary file stored:", getTimer() - testTime);
		//testTime = getTimer();
		//		
		assetLoadWorker.loadStorageBytes(asssetDefinition, data);
	}
	
	//TODO : remove parameter binaryLoad, then benchmarking is no longer needed.
	assetlibrary function handleLoadedContent(asssetDefinition:AssetDefinition, content:Object, applicationDomain:ApplicationDomain, binaryLoad:Boolean = false):void {
		use namespace assetlibrary;
		// benchmarking
		//if (binaryLoad) {
		//trace(" ## binary file converted to object:", getTimer() - testTime);
		//} else {
		//trace(" $$ normal load", getTimer() - testTime);
		//}
		this.lodedFiles++;
		//
		asssetDefinition.setAssetContent(content, applicationDomain);
		this.dispatchEvent(new AssetEvent(AssetEvent.ASSET_LOADED, asssetDefinition.assetId, this.lodedFiles, this.totalFiles, assetLoadWorker.filesInProgress, assetLoadWorker.getProgress()));
		//
		this.loadNextFile();
	}
	
	assetlibrary function handleTextContent(asssetDefinition:AssetDefinition, data:String):void {
		use namespace assetlibrary;
		//
		trace("!!! AssetLibraryLoader.handleTextContent");
		//
		this.lodedFiles++;
		//
		asssetDefinition.setAssetData(data);
		//
		if (isPreloadingXMLs && asssetDefinition.isAssetXmlFile) {
			xmlAssetParser.parseXML(asssetDefinition.asset as XmlAsset);
			assetLibraryIndex.xmlFilesLoaded++;
			this.dispatchEvent(new AssetLoaderEvent(AssetLoaderEvent.XML_LOADED, asssetDefinition.assetId, this.lodedFiles, this.totalFiles, assetLoadWorker.filesInProgress, assetLoadWorker.getProgress()));
			if (assetLibraryIndex.xmlFilesLoaded == assetLibraryIndex.xmlFilesTotal) {
				isPreloadingXMLs = false;
				if (needsPreloading) {
					resetFileCounters();
					needsPreloading = false;
					preloadPermanents();
				}
			}
		} else {
			this.dispatchEvent(new AssetEvent(AssetEvent.ASSET_LOADED, asssetDefinition.assetId, this.lodedFiles, this.totalFiles, assetLoadWorker.filesInProgress, assetLoadWorker.getProgress()));
		}
		//
		this.loadNextFile();
	}
	
	assetlibrary function handleLoadError(asssetDefinition:AssetDefinition, errorText:String):void {
		use namespace assetlibrary;
		errorHandler(Error(errorText + " [assetId:" + asssetDefinition.assetId + "] [assetPath:" + asssetDefinition.filePath + "]"));
		this.lodedFiles++;
		this.loadNextFile();
	}

}
}