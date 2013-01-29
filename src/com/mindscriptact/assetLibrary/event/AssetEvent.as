package com.mindscriptact.assetLibrary.event {
import flash.events.Event;

/**
 * COMMENT
 * @author Raimundas Banevicius
 */
public class AssetEvent extends Event {
	
	static public const XML_LOADING_STARTED:String = "assetXmlLoadingStarted";
	static public const XML_LOADED:String = "assetXmlLoaded";
	//static public const ALL_XMLS_LOADED:String = "allXmlsLoaded";
	
	static public const ASSET_LOADING_STARTED:String = "assetLoadingStarted";
	static public const ASSET_LOADED:String = "assetLoaded";
	
	static public const PROGRESS:String = "assetLoadProgress";
	
	static public const ALL_PERMANENTS_LOADED:String = "allPermanentAssetsLoaded";
	
	public var assetId:String;
	//
	public var filesLoaded:int = 0;
	public var filesQueued:int = 0;
	public var filesInProgress:int = 0;
	//
	public var bytesLoaded:int = 0;
	public var bytesTotal:int = 0;
	
	/** current progress of loading progress. Number from 0 to 1 representing percentages. */
	private var currentProgress:Number = 0;
	
	public function AssetEvent(type:String, assetId:String, filesLoaded:int, filesQueued:int, filesInProgress:int, progress:Number, bytesLoaded:int = 0, bytesTotal:int = 0){
		super(type);
		this.assetId = assetId;
		//
		this.filesLoaded = filesLoaded;
		this.filesQueued = filesQueued;
		this.filesInProgress = filesInProgress;
		//
		this.currentProgress = currentProgress;
		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;
		//
		if (filesQueued){
			var oneFilePart:Number = 1 / filesQueued;
			currentProgress = (filesLoaded * oneFilePart) + ((filesInProgress * oneFilePart) * progress);
		}
	}
	
	override public function toString():String {
		return "[AssetEvent" //
			+ " type=" + type //
			+ " assetId=" + assetId //
			+ " filesLoaded=" + filesLoaded //
			+ " filesQueued=" + filesQueued //
			+ " filesInProgress=" + filesInProgress //
			+ " bytesLoaded=" + bytesLoaded //
			+ " bytesTotal=" + bytesTotal //
			+ "]";
	}
}
}