package mindscriptact.assetLibrary.core.fakeAssets {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.IBitmapDrawable;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * COMMENT
 * @author rBanevicius
 */
public class FakeAssetHelper {
	
	static public function fakeBitmap(debugText:String = null, width:int = 100, height:int = 100):Bitmap {
		var tempBD:BitmapData = new BitmapData(width, height, false, 0xFF0000);
		
		if (debugText) {
			
			var myTextField:TextField = new TextField();
			myTextField.width = width;
			myTextField.height = height;
			myTextField.text = debugText;
			myTextField.multiline = true;
			myTextField.wordWrap = true;
			tempBD.draw(myTextField);
		}
		
		var retVal:Bitmap = new Bitmap(tempBD);
		
		return retVal;
	}
	
	static public function fakeBitmapData(debugText:String = null, width:int = 100, height:int = 100):BitmapData {
		var retVal:BitmapData = new BitmapData(width, height, false, 0xFF0000);
		
		if (debugText) {
			
			var myTextField:TextField = new TextField();
			myTextField.width = width;
			myTextField.height = height;
			myTextField.text = debugText;
			myTextField.multiline = true;
			myTextField.wordWrap = true;
			retVal.draw(myTextField);
		}
		
		return retVal;
	}
	
	static public function fakeMovieClip(debugText:String = null, width:int = 100, height:int = 100):MovieClip {
		var retVal:MovieClip = new MovieClip();
		
		retVal.graphics.lineStyle(0.1, 0xFF0000);
		retVal.graphics.beginFill(0x0000FF);
		retVal.graphics.drawRect(0, 0, width, height);
		retVal.graphics.endFill();
		
		if (debugText) {
			
			var myTextField:TextField = new TextField();
			myTextField.width = width;
			myTextField.height = height;
			myTextField.text = debugText;
			myTextField.multiline = true;
			myTextField.wordWrap = true;
			
			myTextField.mouseEnabled = false;
			
			retVal.addChild(myTextField);
		}
		
		return retVal;
	}
	
	static public function fakeSprite(debugText:String = null, width:int = 100, height:int = 100):Sprite {
		var retVal:Sprite = new Sprite();
		
		retVal.graphics.lineStyle(0.1, 0xFF0000);
		retVal.graphics.beginFill(0x0000FF);
		retVal.graphics.drawRect(0, 0, width, height);
		retVal.graphics.endFill();
		
		if (debugText) {
			
			var myTextField:TextField = new TextField();
			myTextField.width = width;
			myTextField.height = height;
			myTextField.text = debugText;
			myTextField.multiline = true;
			myTextField.wordWrap = true;
			
			myTextField.mouseEnabled = false;
			
			retVal.addChild(myTextField);
		}
		
		return retVal;
	}
	
	static public function fakeButton(debugText:String = null, width:int = 100, height:int = 100):SimpleButton {
		
		var buttonState:Sprite = new Sprite();
		
		var retVal:SimpleButton = new SimpleButton(buttonState, buttonState, buttonState, buttonState);
		
		buttonState.graphics.lineStyle(0.1, 0xFF0000);
		buttonState.graphics.beginFill(0x0000FF);
		buttonState.graphics.drawRect(0, 0, width, height);
		buttonState.graphics.endFill();
		
		if (debugText) {
			
			var myTextField:TextField = new TextField();
			myTextField.width = width;
			myTextField.height = height;
			myTextField.text = debugText;
			myTextField.multiline = true;
			myTextField.wordWrap = true;
			
			myTextField.mouseEnabled = false;
			
			buttonState.addChild(myTextField);
		}
		
		return retVal;
	}
	
	static public function fakeSound():Sound {
		if (!fakeSoundObj) {
			createFakeSound();
		}
		return fakeSoundObj;
	}
	
	static private var fakeSoundposition:int = 0;
	static private var fakeSoundObj:Sound;
	static private var fakeSoundSamples:Vector.<Number>;
	
	static private function createFakeSound():void {
		fakeSoundObj = new Sound();
		fakeSoundObj.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
		fakeSoundSamples = new Vector.<Number>();
		var amp:Number = 1.0;
		var i:int = 0;
		var mult:Number = 1800 / 44100 * Math.PI * 2;
		while (amp > 0.01) {
			fakeSoundSamples[i] = Math.sin(i * mult) * amp;
			amp *= 0.9998;
			i++;
		}
		fakeSoundSamples.length = i;
	}
	
	static private function onSampleData(event:SampleDataEvent):void {
		for (var i:int = 0; i < 2048; i++) {
			if (fakeSoundposition >= fakeSoundSamples.length) {
				fakeSoundposition = 0;
				return;
			}
			event.data.writeFloat(fakeSoundSamples[fakeSoundposition]);
			event.data.writeFloat(fakeSoundSamples[fakeSoundposition]);
			fakeSoundposition++;
		}
	}

}
}