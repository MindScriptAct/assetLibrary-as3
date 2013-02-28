package mindscriptact.assetLibrary.assets {

/**
 * Wraper for XML asset
 * @author Raimundas Banevicius
 */
public class XMLAsset extends AssetAbstract {
	
	public function XMLAsset(assetId:String) {
		super(assetId);
	}
	
	/**
	 * Get raw file data as String.
	 * @return	data as String.
	 */
	public function getData():String {
		return this.data;
	}
	
	/**
	 * Get data as XML object.
	 * @return	xml objects.
	 */
	public function getXml():XML {
		return new XML(this.data);
	}
}
}