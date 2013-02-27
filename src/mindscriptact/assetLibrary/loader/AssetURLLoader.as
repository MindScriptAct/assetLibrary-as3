package mindscriptact.assetLibrary.loader {
import flash.net.URLLoader;
import mindscriptact.assetLibrary.AssetDefinition;
import mindscriptact.assetLibrary.namespaces.assetlibrary;

/**
 * COMMENT
 * @author Raimundas Banevicius
 */
public class AssetURLLoader extends URLLoader {
	assetlibrary var asssetDefinition:AssetDefinition;
	
	public function AssetURLLoader(){
		super();
	}
	
	assetlibrary function dispose():void {
		use namespace assetlibrary;
		asssetDefinition = null;
		this.data = null;
		this.close();
	}

}
}