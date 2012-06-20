package com.mindscriptact.assetLibrary.loader {
import com.mindscriptact.assetLibrary.AssetDefinition;
import com.mindscriptact.assetLibrary.namespaces.assetlibrary;
import flash.display.Loader;

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