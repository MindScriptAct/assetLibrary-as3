package assetLibraryTest {
import flash.display.DisplayObject;
import flash.display.GraphicsPathCommand;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.utils.getDefinitionByName;

/**
 * Small preloader for main aplication swf file loading.
 * @author Raimundas Banevicius
 */
public class Preloader extends MovieClip {
	private var miniLoader:Sprite;

	public function Preloader(){
		if (stage){
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		addEventListener(Event.ENTER_FRAME, checkFrame);
		loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
		loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);

		// cleate and show miniLoader
		miniLoader = new Sprite();
		miniLoader.addEventListener(Event.ENTER_FRAME, animateMiniLoader);
			
		var stepCount:int = 18;
		var stepRadians:Number = Math.PI * 2  / stepCount;
		for (var i:int = 0; i < stepCount; i++) {
			miniLoader.graphics.lineStyle(3, 0x004080, 1 - (1 / i));
			miniLoader.graphics.drawPath(
				Vector.<int>([GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO]),//
				Vector.<Number>([//
					Math.cos(i * stepRadians) * 15, Math.sin(i * stepRadians) * 15,//
					Math.cos(i * stepRadians) * 30, Math.sin(i * stepRadians) * 30//
					]));
		}

		this.addChild(miniLoader);
		miniLoader.x = stage.stageWidth >> 1; // fast flored division by 2
		miniLoader.y = stage.stageHeight >> 1;
	}
	
	private function animateMiniLoader(e:Event):void {
		miniLoader.rotation += 20;
	}

	private function ioError(e:IOErrorEvent):void {
		trace(e.text);
	}

	private function progress(e:ProgressEvent):void {
		// TODO update loader
	}

	private function checkFrame(e:Event):void {
		if (currentFrame == totalFrames){
			stop();
			loadingFinished();
		}
	}

	private function loadingFinished():void {
		removeEventListener(Event.ENTER_FRAME, checkFrame);
		loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
		loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);

		// remove loader
		miniLoader.removeEventListener(Event.ENTER_FRAME, animateMiniLoader);
		this.removeChild(miniLoader);
		miniLoader = null;
		//
		startup();
	}

	private function startup():void {
		var mainClass:Class = getDefinitionByName("assetLibraryTest.Main") as Class;
		addChild(new mainClass() as DisplayObject);
	}

}

}