package com.mindscriptact.assetLibrary.loader {
import adobe.utils.CustomActions;
import com.mindscriptact.assetLibrary.AssetDefinition;
import com.mindscriptact.assetLibrary.AssetLibraryLoader;
import com.mindscriptact.assetLibrary.event.AssetEvent;
import com.mindscriptact.assetLibrary.event.AssetIndexEvent;
import com.mindscriptact.assetLibrary.namespaces.assetlibrary;
import com.mindscriptact.assetLibrary.sharedObject.AssetLibraryStoradge;
import com.mindscriptact.logmaster.DebugMan;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import flash.utils.getTimer;

/**
 * Handles diferent loader censtruction, pregress and errrors.
 * Tracks of loader cound in use.
 * Is not based on factory patern.
 * @author Raimundas Banevicius
 */
public class AssetLoadWorker {
	
	private var assetLibraryLoader:AssetLibraryLoader;
	
	// standart loading
	private var assetLoaders:Vector.<AssetLoader> = new Vector.<AssetLoader>();
	private var urlLoaders:Vector.<AssetURLLoader> = new Vector.<AssetURLLoader>();
	// binary loading
	private var binaryLoaders:Vector.<AssetURLLoader> = new Vector.<AssetURLLoader>();
	private var binaryAssetLoaders:Vector.<AssetLoader> = new Vector.<AssetLoader>();
	// sound loading
	private var soundLoaders:Vector.<SoundLoader> = new Vector.<SoundLoader>();
	//
	private var assetLoadersInUse:Vector.<AssetLoader> = new Vector.<AssetLoader>();
	private var urlLoadersInUse:Vector.<AssetURLLoader> = new Vector.<AssetURLLoader>();
	private var soundLoadersInUse:Vector.<SoundLoader> = new Vector.<SoundLoader>();
	//
	
	assetlibrary var filesInProgress:int = 0;
	
	public function AssetLoadWorker(assetLibraryLoader:AssetLibraryLoader){
		this.assetLibraryLoader = assetLibraryLoader;
	}
	
	//----------------------------------
	//     Asset loader getters
	//----------------------------------
	
	private function getAssetLoader(loadItem:AssetDefinition):AssetLoader {
		use namespace assetlibrary;
		var assetLoader:AssetLoader;
		if (assetLoaders.length){
			assetLoader = assetLoaders.pop();
		} else {
			assetLoader = new AssetLoader();
			assetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleFileLoad);
			assetLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleFileProgress);
			assetLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleAssetError);
			assetLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleAssetError);
		}
		assetLoader.asssetDefinition = loadItem;
		//
		assetLoadersInUse.push(assetLoader);
		filesInProgress++;
		//
		return assetLoader;
	}
	
	private function getBinaryAssetLoader(loadItem:AssetDefinition):AssetLoader {
		use namespace assetlibrary;
		var binaryAssetLoader:AssetLoader;
		if (binaryAssetLoaders.length){
			binaryAssetLoader = binaryAssetLoaders.pop();
		} else {
			binaryAssetLoader = new AssetLoader();
			binaryAssetLoader.isConverter = true;
			binaryAssetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleConvertFinished);
			binaryAssetLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleFileProgress);
			binaryAssetLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleAssetError);
			binaryAssetLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleAssetError);
		}
		binaryAssetLoader.asssetDefinition = loadItem;
		//
		assetLoadersInUse.push(binaryAssetLoader);
		filesInProgress++;
		//
		return binaryAssetLoader;
	}
	
	private function getAssetUrlLoader(loadItem:AssetDefinition):AssetURLLoader {
		use namespace assetlibrary;
		var urlLoader:AssetURLLoader;
		if (urlLoaders.length){
			urlLoader = urlLoaders.pop();
		} else {
			urlLoader = new AssetURLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleTextLoad);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, handleTextProgress);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleFileError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleFileError);
		}
		urlLoader.asssetDefinition = loadItem;
		//
		urlLoadersInUse.push(urlLoader);
		filesInProgress++;
		//
		return urlLoader;
	}
	
	private function getBinaryUrlLoader(loadItem:AssetDefinition):AssetURLLoader {
		use namespace assetlibrary;
		var binaryLoader:AssetURLLoader;
		if (binaryLoaders.length){
			binaryLoader = binaryLoaders.pop()
		} else {
			binaryLoader = new AssetURLLoader();
			binaryLoader.dataFormat = URLLoaderDataFormat.BINARY;
			binaryLoader.addEventListener(Event.COMPLETE, handleBinaryFileLoad);
			binaryLoader.addEventListener(ProgressEvent.PROGRESS, handleTextProgress);
			binaryLoader.addEventListener(IOErrorEvent.IO_ERROR, handleFileError);
			binaryLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleFileError);
		}
		binaryLoader.asssetDefinition = loadItem;
		//
		urlLoadersInUse.push(binaryLoader);
		filesInProgress++;
		//
		return binaryLoader;
	}
	
	private function getSoundLoader(loadItem:AssetDefinition):SoundLoader {
		use namespace assetlibrary;
		var soundLoader:SoundLoader;
		if (soundLoaders.length){
			soundLoader = soundLoaders.pop();
		} else {
			soundLoader = new SoundLoader();
			soundLoader.addEventListener(Event.COMPLETE, handleSoundLoad);
			soundLoader.addEventListener(ProgressEvent.PROGRESS, handleSoundProgress);
			soundLoader.addEventListener(IOErrorEvent.IO_ERROR, handleSoundError);
			soundLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSoundError);
				//soundLoader.addEventListener(Event.ID3, handleId3);
		}
		soundLoader.asssetDefinition = loadItem;
		//
		soundLoadersInUse.push(soundLoader);
		filesInProgress++;
		//
		return soundLoader;
	}
	
	//----------------------------------
	//     Asset loader dispose
	//----------------------------------
	
	private function disposeAssetLoader(loader:AssetLoader):void {
		use namespace assetlibrary;
		loader.dispose();
		for (var i:int = 0; i < assetLoadersInUse.length; i++){
			if (assetLoadersInUse[i] == loader){
				assetLoadersInUse.splice(i, 1);
				break;
			}
		}
		assetLoaders.push(loader);
	}
	
	private function disposeBinaryAssetLoader(loader:AssetLoader):void {
		use namespace assetlibrary;
		loader.dispose();
		for (var i:int = 0; i < assetLoadersInUse.length; i++){
			if (assetLoadersInUse[i] == loader){
				assetLoadersInUse.splice(i, 1);
				break;
			}
		}
		binaryAssetLoaders.push(loader);
	
	}
	
	private function disposeAssetUrlLoader(loader:AssetURLLoader):void {
		use namespace assetlibrary;
		loader.dispose();
		for (var i:int = 0; i < urlLoadersInUse.length; i++){
			if (urlLoadersInUse[i] == loader){
				urlLoadersInUse.splice(i, 1);
				break;
			}
		}
		urlLoaders.push(loader);
	
	}
	
	private function disposeBinaryUrlLoader(loader:AssetURLLoader):void {
		use namespace assetlibrary;
		loader.dispose();
		for (var i:int = 0; i < urlLoadersInUse.length; i++){
			if (urlLoadersInUse[i] == loader){
				urlLoadersInUse.splice(i, 1);
				break;
			}
		}
		binaryLoaders.push(loader);
	
	}
	
	private function disposeSoundLoader(loader:SoundLoader):void {
		use namespace assetlibrary;
		loader.dispose();
		for (var i:int = 0; i < soundLoadersInUse.length; i++){
			if (soundLoadersInUse[i] == loader){
				soundLoadersInUse.splice(i, 1);
				break;
			}
		}
		soundLoaders.push(loader);
	}
	
	//----------------------------------
	//     Load Starters
	//----------------------------------
	
	assetlibrary function loadNormally(loadItem:AssetDefinition):void {
		use namespace assetlibrary;
		getAssetLoader(loadItem).load(new URLRequest(assetLibraryLoader.rootPath + loadItem.filePath));
	}
	
	assetlibrary function loadStoradgeBytes(loadItem:AssetDefinition, binary:ByteArray):void {
		getBinaryAssetLoader(loadItem).loadBytes(binary);
	}
	
	assetlibrary function loadBinary(loadItem:AssetDefinition):void {
		use namespace assetlibrary;
		getBinaryUrlLoader(loadItem).load(new URLRequest(assetLibraryLoader.rootPath + loadItem.filePath));
	}
	
	assetlibrary function loadText(loadItem:AssetDefinition):void {
		use namespace assetlibrary;
		getAssetUrlLoader(loadItem).load(new URLRequest(assetLibraryLoader.rootPath + loadItem.filePath));
	}
	
	assetlibrary function loadSound(loadItem:AssetDefinition):void {
		use namespace assetlibrary;
		getSoundLoader(loadItem).load(new URLRequest(assetLibraryLoader.rootPath + loadItem.filePath));
	}
	
	//----------------------------------
	//     binary load handling
	//----------------------------------
	
	private function handleBinaryFileLoad(event:Event):void {
		use namespace assetlibrary;
		var binaryLoader:AssetURLLoader = event.target as AssetURLLoader;
		filesInProgress--;
		assetLibraryLoader.handleBinaryDataLoad(binaryLoader.asssetDefinition, binaryLoader.data as ByteArray);
		//
		disposeBinaryUrlLoader(binaryLoader);
	}
	
	private function handleConvertFinished(event:Event):void {
		use namespace assetlibrary;
		var binaryAssetLoader:AssetLoader = (event.target as LoaderInfo).loader as AssetLoader;
		filesInProgress--;
		assetLibraryLoader.handleLoadedContent(binaryAssetLoader.asssetDefinition, binaryAssetLoader.content, binaryAssetLoader.contentLoaderInfo.applicationDomain, true);
		//
		disposeBinaryAssetLoader(binaryAssetLoader);
	}
	
	//----------------------------------
	//     normal file loads
	//----------------------------------
	
	private function handleFileLoad(event:Event):void {
		use namespace assetlibrary;
		var assetLoader:AssetLoader = (event.target as LoaderInfo).loader as AssetLoader;
		filesInProgress--;
		assetLibraryLoader.handleLoadedContent(assetLoader.asssetDefinition, assetLoader.content, assetLoader.contentLoaderInfo.applicationDomain, false);
		//
		disposeAssetLoader(assetLoader);
	}
	
	private function handleTextLoad(event:Event):void {
		use namespace assetlibrary;
		var urlLoader:AssetURLLoader = event.target as AssetURLLoader;
		filesInProgress--;
		assetLibraryLoader.handleTextContent(urlLoader.asssetDefinition, urlLoader.data);
		//
		disposeAssetUrlLoader(urlLoader);
	}
	
	private function handleSoundLoad(event:Event):void {
		use namespace assetlibrary;
		var soundLoader:SoundLoader = event.target as SoundLoader;
		filesInProgress--;
		assetLibraryLoader.handleLoadedContent(soundLoader.asssetDefinition, soundLoader.sound, null);
		//
		disposeSoundLoader(soundLoader);
	}
	
	//----------------------------------
	//     progress handling
	//----------------------------------
	
	private function handleFileProgress(event:ProgressEvent):void {
		use namespace assetlibrary;
		var assetLoader:AssetLoader = (event.target as LoaderInfo).loader as AssetLoader;
		assetLibraryLoader.dispatchEvent(new AssetEvent(AssetEvent.PROGRESS, assetLoader.asssetDefinition.assetId, assetLibraryLoader.lodedFiles, assetLibraryLoader.totalFiles, this.filesInProgress, event.bytesLoaded, event.bytesTotal));
	}
	
	private function handleTextProgress(event:ProgressEvent):void {
		use namespace assetlibrary;
		var assetLoader:AssetURLLoader = event.target as AssetURLLoader;
		assetLibraryLoader.dispatchEvent(new AssetEvent(AssetEvent.PROGRESS, assetLoader.asssetDefinition.assetId, assetLibraryLoader.lodedFiles, assetLibraryLoader.totalFiles, this.filesInProgress, event.bytesLoaded, event.bytesTotal));
	}
	
	private function handleSoundProgress(event:ProgressEvent):void {
		use namespace assetlibrary;
		var assetLoader:SoundLoader = event.target as SoundLoader;
		assetLibraryLoader.dispatchEvent(new AssetEvent(AssetEvent.PROGRESS, assetLoader.asssetDefinition.assetId, assetLibraryLoader.lodedFiles, assetLibraryLoader.totalFiles, this.filesInProgress, event.bytesLoaded, event.bytesTotal));
	}
	
	//----------------------------------
	//     error handling
	//----------------------------------
	
	private function handleAssetError(event:IOErrorEvent):void {
		use namespace assetlibrary;
		var assetLoader:AssetLoader = (event.target as LoaderInfo).loader as AssetLoader;
		filesInProgress--;
		assetLibraryLoader.handleLoadError(assetLoader.asssetDefinition, event.text);
		//
		if (assetLoader.isConverter){
			disposeBinaryAssetLoader(assetLoader);
		} else {
			disposeAssetLoader(assetLoader);
		}
	}
	
	private function handleFileError(event:IOErrorEvent):void {
		use namespace assetlibrary;
		var assetUrlLoader:AssetURLLoader = event.target as AssetURLLoader;
		filesInProgress--;
		assetLibraryLoader.handleLoadError(assetUrlLoader.asssetDefinition, event.text);
		//
		//assetUrlLoader.dispose();
		if (assetUrlLoader.dataFormat == URLLoaderDataFormat.BINARY){
			disposeBinaryUrlLoader(assetUrlLoader);
		} else {
			disposeAssetUrlLoader(assetUrlLoader);
		}
	
	}
	
	private function handleSoundError(event:IOErrorEvent):void {
		use namespace assetlibrary;
		var soundLoader:SoundLoader = event.target as SoundLoader;
		filesInProgress--;
		assetLibraryLoader.handleLoadError(soundLoader.asssetDefinition, event.text);
		//
		disposeSoundLoader(soundLoader);
	}
	
	//----------------------------------
	//     
	//----------------------------------
	
	assetlibrary function getProgress():Number {
		use namespace assetlibrary;
		var bytesLoadedSum:int = 0;
		var bytesTotal:int = 0;
		for (var i:int = 0; i < assetLoadersInUse.length; i++) {
			var loaderInfo:LoaderInfo = assetLoadersInUse[i].contentLoaderInfo;
			if (loaderInfo) {
				bytesLoadedSum += loaderInfo.bytesLoaded;
				bytesTotal += loaderInfo.bytesTotal;
			}
		}
		for (i = 0; i < urlLoadersInUse.length; i++){
			bytesLoadedSum += urlLoadersInUse[i].bytesLoaded;
			bytesTotal += urlLoadersInUse[i].bytesTotal;
		}
		for (i = 0; i < soundLoadersInUse.length; i++){
			bytesLoadedSum += soundLoadersInUse[i].sound.bytesLoaded;
			bytesTotal += soundLoadersInUse[i].sound.bytesTotal;
		}
		if (bytesTotal){
			return bytesLoadedSum / bytesTotal;
		} else {
			return 0;
		}
	}
}

}