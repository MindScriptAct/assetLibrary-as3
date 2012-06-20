package com.mindscriptact.assetLibrary.assets {
import com.mindscriptact.assetLibrary.AssetAbstract;

/**
 * Wraper for XML asset
 * @author Raimundas Banevicius
 */
public class XMLAsset extends AssetAbstract {

	public function XMLAsset(assetId:String){
		super(assetId);
	}

	//public function getAssetContent(): {
		//return content as DisplayObject;
	//}
		
	public function getData():String {
		return this.data;
	}
}
}