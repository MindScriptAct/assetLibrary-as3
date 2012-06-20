package com.mindscriptact.assetLibrary.loader {
import com.mindscriptact.assetLibrary.AssetDefinition;
import com.mindscriptact.assetLibrary.namespaces.assetlibrary;
import flash.net.URLLoader;

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