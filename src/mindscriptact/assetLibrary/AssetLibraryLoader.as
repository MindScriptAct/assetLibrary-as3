package mindscriptact.assetLibrary {
import flash.events.EventDispatcher;
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;
import flash.utils.getTimer;
import mindscriptact.assetLibrary.assets.XMLAsset;
import mindscriptact.assetLibrary.core.AssetDefinition;
import mindscriptact.assetLibrary.core.AssetType;
import mindscriptact.assetLibrary.core.loader.AssetLoadWorker;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;
import mindscriptact.assetLibrary.core.sharedObject.AssetLibraryStoradge;
import mindscriptact.assetLibrary.core.xml.AssetXmlParser;
import mindscriptact.assetLibrary.events.AssetEvent;
import mindscriptact.assetLibrary.events.AssetLoaderEvent;
import mindscriptact.logmaster.DebugMan;

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
	private var localStoradge:AssetLibraryStoradge;
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
	internal var handleStoradgeFail:Function = internalHandleStoradgeFail;
	assetlibrary var _localStoradgeEnabled:Boolean = false;
	//
	private var errorHandler:Function;
	assetlibrary var rootPath:String = "";
	//
	public var testTime:int;
	assetlibrary var maxSimultaneousLoads:int = 3;
	//
	//
	assetlibrary var lodedFiles:int = 0;
	assetlibrary var totalFiles:int = 0;
	//
	assetlibrary var lodedXMLFiles:int = 0;
	assetlibrary var totalXMLFiles:int = 0;
	
	//
	public function AssetLibraryLoader(assetLibraryIndex:AssetLibraryIndex, localStoradge:AssetLibraryStoradge, errorHandler:Function) {
		this.assetLibraryIndex = assetLibraryIndex;
		this.localStoradge = localStoradge;
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
			DebugMan.info("filesForPreloading : " + filesForPreloading);
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
	
	internal function loadAsset(item:AssetDefinition):void {
		use namespace assetlibrary;
		//DebugMan.info("AssetLibraryLoader.loadAsset > item : " + item);
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
					if (_localStoradgeEnabled) {
						if (localStoradge.canUseStore()) {
							loadNarmaly = false;
						} else {
							handleStoradgeFail();
						}
					}
					if (loadNarmaly) {
						assetLoadWorker.loadNormally(loadItem);
					} else {
						testTime = getTimer();
						var binary:ByteArray = localStoradge.get(loadItem.assetId, loadItem.filePath);
						DebugMan.info(" >> binary file retreved !:", (getTimer() - testTime), "data exists:", (binary != null));
						testTime = getTimer();
						if (binary) {
							assetLoadWorker.loadStoradgeBytes(loadItem, binary);
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
					DebugMan.info("WARNING : type is not handled.", loadItem.type);
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
	
	public function get isLoading():Boolean {
		return _isLoading;
	}
	
	public function get localStoradgeEnabled():Boolean {
		use namespace assetlibrary;
		return _localStoradgeEnabled;
	}
	
	private function handleXmlLoadStart(assetDefinition:AssetDefinition):void {
		//DebugMan.info("AssetLibraryLoader.handleXmlLoadStart > event : " + event.assetDefinition.assetId);
		isPreloadingXMLs = true;
		loadAsset(assetDefinition);
	}
	
	private function internalHandleStoradgeFail():void {
		errorHandler(Error("AssitLibrary failed to store data localy, and handleStoradgeFail is not set.(Maybe its disabled compleatly.) Use AssetLibrary.setStoradgeFailHandler(handlerFunction);"));
	}
	
	//----------------------------------
	//     loaded content handling. (invoked by AssetLoaderWorker)
	//----------------------------------
	
	assetlibrary function handleBinaryDataLoad(asssetDefinition:AssetDefinition, data:ByteArray):void {
		use namespace assetlibrary;
		DebugMan.info(" @@ binary file loaded:", getTimer() - testTime);
		testTime = getTimer();
		//
		if (!localStoradge.store(asssetDefinition.assetId, asssetDefinition.filePath, data)) {
			errorHandler(Error("Storing assit to local SharedObject failed." + " [assetId:" + asssetDefinition.assetId + "] [assetPath:" + asssetDefinition.filePath + "]"));
		}
		DebugMan.info(" << binary file stored:", getTimer() - testTime);
		testTime = getTimer();
		//		
		assetLoadWorker.loadStoradgeBytes(asssetDefinition, data);
	}
	
	//TODO : remove parameter binaryLoad, then benchmarking is no longer needed.
	assetlibrary function handleLoadedContent(asssetDefinition:AssetDefinition, content:Object, applicationDomain:ApplicationDomain, binaryLoad:Boolean = false):void {
		use namespace assetlibrary;
		// benchmarking
		if (binaryLoad) {
			DebugMan.info(" ## binary file converted to object:", getTimer() - testTime);
		} else {
			DebugMan.info(" $$ normal load", getTimer() - testTime);
		}
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
		DebugMan.info("!!! AssetLibraryLoader.handleTextContent");
		//
		this.lodedFiles++;
		//
		asssetDefinition.setAssetData(data);
		//
		if (isPreloadingXMLs && asssetDefinition.isAssetXmlFile) {
			xmlAssetParser.parseXML(asssetDefinition.asset as XMLAsset);
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