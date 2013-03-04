package mindscriptact.assetLibrary.core.xml {
import mindscriptact.assetLibrary.AssetLibraryIndex;
import mindscriptact.assetLibrary.assets.XmlAsset;

/**
 * Asset xml file parser.
 * @private
 * @author Deril
 */
public class AssetXmlParser {
	private var assetIndex:AssetLibraryIndex;
	
	public function AssetXmlParser(assetIndex:AssetLibraryIndex) {
		this.assetIndex = assetIndex;
	}
	
	public function parseXML(asset:XmlAsset):void {
		var assetXml:XML = new XML(asset.getData());
		// path's
		var elementCount:int = assetXml.path.length();
		for (var p:int = 0; p < elementCount; p++) {
			parsePath(assetXml.path[p]);
		}
		
		// groups
		elementCount = assetXml.group.length();
		for (var g:int = 0; g < elementCount; g++) {
			parseGroup(assetXml.group[g]);
		}
		
		// files outside path's and groups
		elementCount = assetXml.file.length();
		for (var f:int = 0; f < elementCount; f++) {
			parseFileXml(assetXml.file[f]);
		}
	}
	
	private function parsePath(pathXml:XML, groupId:String = null):void {
		assetIndex.addPathDefinition(pathXml.@pathId, pathXml.@url, pathXml.@dynamicPathAssetType);
		// files in path's
		var elementCount:int = pathXml.file.length();
		for (var f:int = 0; f < elementCount; f++) {
			parseFileXml(pathXml.file[f], pathXml.@pathId, groupId);
		}
		// groups in path's
		if (!groupId) {
			elementCount = pathXml.group.length();
			for (var g:int = 0; g < elementCount; g++) {
				parseGroup(pathXml.group[g], pathXml.@pathId);
			}
		}
	
	}
	
	private function parseGroup(groupXml:XML, pathId:String = null):void {
		// files in group's
		var elementCount:int = groupXml.file.length();
		for (var f:int = 0; f < elementCount; f++) {
			if (String(groupXml.@fileUrl) != "" && String(groupXml.@assetType) != "") {
				parseFileXml(groupXml.file[f], pathId, groupXml.@groupId);
			}
		}
		// path's in group
		if (!pathId) {
			elementCount = groupXml.path.length();
			for (var p:int = 0; p < elementCount; p++) {
				parsePath(groupXml.path[p], groupXml.@groupId);
			}
		}
	}
	
	private function parseFileXml(fileXml:XML, pathId:String = null, groupId:String = null):void {
		
		if (!pathId) {
			if (fileXml.@pathId) {
				pathId = fileXml.@pathId;
			}
		}
		
		var isPermanent:Boolean = false;
		var urlParams:String = null;
		var assetType:String = null;
		
		if (String(fileXml.@isPermanent) != "") {
			isPermanent = (fileXml.@isPermanent == "true");
		}
		if (String(fileXml.@urlParams) != "") {
			urlParams = fileXml.@urlParams;
		}
		if (String(fileXml.@assetType) != "") {
			assetType = fileXml.@assetType;
		}
		assetIndex.addFileDefinition(fileXml.@assetId, fileXml.@fileUrl, pathId, isPermanent, urlParams, assetType);
		//
		if (!groupId) {
			assetIndex.addAssetToGroup(groupId, fileXml.@assetId);
		}
	}

}
}