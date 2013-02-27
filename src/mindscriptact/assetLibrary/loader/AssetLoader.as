package mindscriptact.assetLibrary.loader {
import flash.display.Loader;
import mindscriptact.assetLibrary.AssetDefinition;
import mindscriptact.assetLibrary.namespaces.assetlibrary;

/**
 * COMMENT
 * @author Raimundas Banevicius
 */
public class AssetLoader extends Loader {
	assetlibrary var asssetDefinition:AssetDefinition;
	
	assetlibrary var isConverter:Boolean = false;
	
	public function AssetLoader(){
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