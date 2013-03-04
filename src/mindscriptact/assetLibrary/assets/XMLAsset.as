package mindscriptact.assetLibrary.assets {

/**
 * Wraper for XML asset
 * @author Raimundas Banevicius
 */
public class XmlAsset extends AssetAbstract {
	
	public function XmlAsset(assetId:String) {
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