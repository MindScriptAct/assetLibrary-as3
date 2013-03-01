package mindscriptact.assetLibrary.assets {
import flash.system.ApplicationDomain;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;

/**
 * Abstract asset to extends all other asset objects from.
 * @author Raimundas Banevicius
 */
public class AssetAbstract {
	
	protected var _assetId:String;
	
	protected var data:String;
	protected var content:Object;
	protected var applicationDomain:ApplicationDomain;
	
	protected var _isLoaded:Boolean = false;
	protected var _isPermanent:Boolean = false;
	
	static protected var _fakeMissingAssets:Boolean = false;
	
	public function AssetAbstract(assetId:String) {
		this._assetId = assetId;
	}
	
	//----------------------------------
	//     Asset api
	//----------------------------------
	
	/**
	 * Clear asset data.
	 */
	public function unload():void {
		data = null;
		content = null;
		applicationDomain = null;
		_isLoaded = false;
	}
	
	/**
	 * true - if asset is loaded.
	 */
	public function get isLoaded():Boolean {
		return _isLoaded;
	}
	
	/**
	 * true - if asset is permanents
	 */
	public function get isPermanent():Boolean {
		return _isPermanent;
	}
	
	/**
	 * Returns assetId.
	 */
	public function get assetId():String {
		return _assetId;
	}
	
	//----------------------------------
	//     internal
	//----------------------------------
	
	static assetlibrary function set fakeMissingAssets(value:Boolean):void {
		_fakeMissingAssets = value;
	}
	
	assetlibrary function setData(data:String):void {
		//CONFIG::debug {
		//if (this.data){
		//throw Error("AssetAbstract data should not be set twice");
		//}
		//}
		this.data = data;
		_isLoaded = true;
	}
	
	assetlibrary function setContent(content:Object, applicationDomain:ApplicationDomain, isPermanent:Boolean):void {
		//CONFIG::debug {
		//if (this.content){
		//throw Error("AssetAbstract content should not be set twice");
		//}
		//}
		this.content = content;
		this.applicationDomain = applicationDomain;
		_isPermanent = isPermanent;
		_isLoaded = true;
	}

}
}