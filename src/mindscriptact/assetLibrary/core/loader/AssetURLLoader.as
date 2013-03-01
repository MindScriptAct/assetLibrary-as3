package mindscriptact.assetLibrary.core.loader {
import flash.net.URLLoader;
import mindscriptact.assetLibrary.core.AssetDefinition;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;

/**
 * Asset URL loader
 * @private
 * @author Raimundas Banevicius
 */
public class AssetURLLoader extends URLLoader {
	
	assetlibrary var asssetDefinition:AssetDefinition;
	
	public function AssetURLLoader() {
		super();
	}
	
	assetlibrary function dispose():void {
		use namespace assetlibrary;
		close();
		asssetDefinition = null;
		data = null;
	}

}
}