package mindscriptact.assetLibrary.assets {

/**
 * Wraper for XML asset
 * @author Raimundas Banevicius
 */
public class XMLAsset extends AssetAbstract {
	
	public function XMLAsset(assetId:String) {
		super(assetId);
	}
	
	//public function getAssetContent(): {
	//return content as DisplayObject;
	//}
	
	public function getData():String {
		return this.data;
	}
	
	public function getXml():XML {
		return new XML(this.data);
	}
}
}