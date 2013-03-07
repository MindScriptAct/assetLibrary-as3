package {
import flash.display.*;
import noiseandheat.flexunit.visuallistener.VisualListener;
import org.flexunit.internals.TraceListener;
import org.flexunit.runner.FlexUnitCore;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MainTestRunner extends Sprite {
	private var listener:VisualListener;
	
	static public var stage:Stage;
	
	public function MainTestRunner() {
		// set up
		this.stage.align = StageAlign.TOP_LEFT;
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
		//
		MainTestRunner.stage = this.stage;
		
		//
		var core:FlexUnitCore = new FlexUnitCore();
		//
		core.addListener(new TraceListener());
		//
		listener = new VisualListener(this.stage.stageWidth, this.stage.stageHeight);
		addChild(listener);
		core.addListener(listener);
		
		//----------------------------------
		//     Tests!
		//----------------------------------
		
		core.run(AllTestSuites);
	}

}
}