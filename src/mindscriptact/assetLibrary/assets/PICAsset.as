package mindscriptact.assetLibrary.assets {
import flash.display.Bitmap;
import flash.display.BitmapData;

/**
 * Wraper for picture assets: jpg, png, gif
 * @author Raimundas Banevicius
 */
public class PICAsset extends AssetAbstract {
	
	public function PICAsset(assetId:String) {
		super(assetId);
	}
	
	/**
	 * Gives PIC asset Bitmap instance with loaded BitmapData content.
	 * This metod does not clone pictures BitmapData, that means it will not use extra memory to show extra copies.
	 * If you modify it's content - all other not cloned instances of same Pic will be modified with it,
	 *   and all new cloned instances will clone those changes.
	 * @return	Bitmap instance with picture of PIC asset
	 */
	public function getBitmap():Bitmap {
		var bd:BitmapData = (content as Bitmap).bitmapData;
		return new Bitmap(bd);
	}
	
	/**
	 * Gives PIC asset Bitmap instance with loaded BitmapData content.
	 * This method will create a clone of picture.
	 * It's possible to modify it without modifiing original loaded picture.
	 * @return	Bitmap instance with picture of PIC asset
	 */
	public function getClonedBitmap():Bitmap {
		var bd:BitmapData = (content as Bitmap).bitmapData;
		return new Bitmap(bd.clone());
	}

}
}