package mindscriptact.assetLibrary.events {
import flash.events.Event;

/**
 * General asset Library loading event.
 * @author Raimundas Banevicius
 */
public class AssetLoaderEvent extends Event {
	
	/** xml with file definitiens loading start event */
	static public const XML_LOADING_STARTED:String = "assetXmlLoadingStarted";
	
	/** xml with file definitiens loading end event */
	static public const XML_LOADED:String = "assetXmlLoaded";
	
	/** all permanents loaded */
	static public const ALL_PERMANENTS_LOADED:String = "allPermanentAssetsLoaded";
	
	/** Asset id if event is asset related. */
	public var assetId:String;
	//
	public var filesLoaded:int = 0;
	public var filesQueued:int = 0;
	public var filesInProgress:int = 0;
	
	/** current progress of loading progress. Number from 0 to 1 representing percentages. */
	public var currentProgress:Number = 0;
	
	public function AssetLoaderEvent(type:String, assetId:String, filesLoaded:int, filesQueued:int, filesInProgress:int, progress:Number) {
		super(type);
		this.assetId = assetId;
		//
		this.filesLoaded = filesLoaded;
		this.filesQueued = filesQueued;
		this.filesInProgress = filesInProgress;
		//
		if (filesQueued) {
			var oneFilePart:Number = 1 / filesQueued;
			currentProgress = (filesLoaded * oneFilePart) + ((filesInProgress * oneFilePart) * progress);
		}
	}
	
	override public function toString():String {
		return "[AssetLoaderEvent" //
			+ " type=" + type //
			+ " assetId=" + assetId //
			+ " filesLoaded=" + filesLoaded //
			+ " filesQueued=" + filesQueued //
			+ " filesInProgress=" + filesInProgress //
			+ "]";
	}
}
}