package mindscriptact.assetLibrary.core {
import flash.system.ApplicationDomain;
import mindscriptact.assetLibrary.assets.AssetAbstract;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;

/**
 * INTERNAL. Asset definition.
 * @private
 * @author Raimundas Banevicius
 */
public class AssetDefinition {
	
	public var assetId:String;
	//
	public var asset:AssetAbstract;
	//
	public var filePath:String;
	public var type:String;
	//
	public var isPermanent:Boolean = false;
	//
	public var isAssetXmlFile:Boolean = false;
	//
	public var callBackFunctions:Vector.<Function> = new Vector.<Function>();
	public var callBackParams:Vector.<Array> = new Vector.<Array>;
	//
	private var _keepTime:int = int.MAX_VALUE;
	
	public function AssetDefinition(assetId:String, filePath:String, type:String, isPermanent:Boolean = false) {
		use namespace assetlibrary;
		this.assetId = assetId;
		//
		this.filePath = filePath;
		this.type = type;
		this.isPermanent = isPermanent;
	}
	
	assetlibrary function setAssetData(data:String):void {
		use namespace assetlibrary;
		if (asset) {
			if (_keepTime > 0) {
				asset.setData(data);
			}
			_keepTime = int.MAX_VALUE;
			//
			while (callBackFunctions.length) {
				var params:Array = callBackParams.pop();
				params.unshift(asset);
				callBackFunctions.pop().apply(null, params);
			}
		}
	}
	
	assetlibrary function setAssetContent(content:Object, applicationDomain:ApplicationDomain):void {
		use namespace assetlibrary;
		if (asset) {
			if (_keepTime > 0) {
				asset.setContent(content, applicationDomain, isPermanent);
			}
			_keepTime = int.MAX_VALUE;
			//
			while (callBackFunctions.length) {
				var params:Array = callBackParams.pop();
				params.unshift(asset);
				callBackFunctions.pop().apply(null, params);
			}
		}
	}
	
	public function toString():String {
		use namespace assetlibrary;
		return "[AssetDefinition" //
			+ " assetId=" + assetId //
			+ " filePath=" + filePath //
			+ " type=" + type //
			+ " isPermanent=" + isPermanent //
			+ " isLoaded=" + isLoaded //
			+ "]";
	}
	
	assetlibrary function get isLoaded():Boolean {
		use namespace assetlibrary;
		if (asset) {
			return asset.isLoaded;
		} else {
			return false;
		}
	}
	
	assetlibrary function set keepTime(value:int):void {
		if (_keepTime == int.MAX_VALUE) {
			_keepTime = value;
		} else if (_keepTime < value) {
			_keepTime = value;
		}
	}
	
	public function unload():void {
		if (asset) {
			asset.unload();
			asset = null;
			//
			callBackFunctions = null;
			callBackParams = null;
		}
	}
}
}