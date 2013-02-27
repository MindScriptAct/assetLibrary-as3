package mindscriptact.assetLibrary.xml {

/**
 * ...
 * @author Deril
 */
public class XMLDefinition {
	public var assetId:String;

	public var isLoaded:Boolean = false;

	public var fileAssetIds:Vector.<String> = new Vector.<String>();

	public function XMLDefinition(assetId:String){
		this.assetId = assetId;
	}

}

}