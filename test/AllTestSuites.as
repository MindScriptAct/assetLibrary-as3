package {
import integration.assetDefine.AssetDefineTests;
import integration.assetVersioning.AssetVersioningTests;
import integration.core.CoreTests;
import integration.loding.basic.LoadingTests;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */

[Suite]
[RunWith("org.flexunit.runners.Suite")]

public class AllTestSuites {

	///*

	public var coreTests:CoreTests;

	public var assetDefineTests:AssetDefineTests;

	public var assetVelsioning:AssetVersioningTests;

	//public var assetLibraryStorageVersioning:AssetLibraryStorageVersioning;

	//*/

	public var loadingTests:LoadingTests;
}

}