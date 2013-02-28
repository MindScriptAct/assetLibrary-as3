package mindscriptact.assetLibrary.core.loader {
import flash.display.Loader;
import mindscriptact.assetLibrary.core.AssetDefinition;
import mindscriptact.assetLibrary.core.namespaces.assetlibrary;

/**
 * Asset loader
 * @private
 * @author Raimundas Banevicius
 */
public class AssetLoader extends Loader {
	
	assetlibrary var asssetDefinition:AssetDefinition;
	
	assetlibrary var isConverter:Boolean = false;
	
	public function AssetLoader() {
		super();
	}
	
	assetlibrary function dispose():void {
		use namespace assetlibrary;
		asssetDefinition = null;
		unload();
		//close();
	}

}
}