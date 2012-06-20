package com.mindscriptact.assetLibrary.event {
import com.mindscriptact.assetLibrary.AssetDefinition;
import flash.events.Event;

/**
 * ...
 * @author Deril
 */
public class AssetIndexEvent extends Event {

	static public const START_XML_LOAD:String = "assetIndexStartXmlLoad";

	public var assetDefinition:AssetDefinition;

	public function AssetIndexEvent(type:String, assetDefinition:AssetDefinition){
		super(type);
		this.assetDefinition = assetDefinition;
	}

}
}