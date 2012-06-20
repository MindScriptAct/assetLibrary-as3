package com.mindscriptact.assetLibrary {
import com.mindscriptact.assetLibrary.namespaces.assetlibrary;
import flash.system.ApplicationDomain;

/**
 * COMMENT
 * @author Raimundas Banevicius
 */
public class AssetAbstract {

	protected var _assetId:String;

	protected var data:String;
	protected var content:Object;
	protected var applicationDomain:ApplicationDomain;

	protected var _isLoaded:Boolean = false;
	protected var _isPermanent:Boolean = false;


	public function AssetAbstract(assetId:String){
		this._assetId = assetId;
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
		this.content = content
		this.applicationDomain = applicationDomain;
		_isPermanent = isPermanent;
		_isLoaded = true;
	}

	public function unload():void {	
		data = null;
		content = null;
		applicationDomain = null;
		_isLoaded = false;
	}



	public function get isLoaded():Boolean {
		return _isLoaded;
	}

	public function get isPermanent():Boolean {
		return _isPermanent;
	}
	
	public function get assetId():String {
		return _assetId;
	}

}
}