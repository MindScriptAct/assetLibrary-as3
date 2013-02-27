
/**
 * Hi-ReS! Stats
 *
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 *
 *	addChild( new Stats() );
 *
 *	or
 *
 *	addChild( new Stats( { bg: 0xffffff } );
 *
 * version log:
 *
 *	09.09.27		3.0		Deril			+ Altered name and creation (made same as other fps counters.)
 *	09.03.28		2.1		Mr.doob			+ $theme support.
 *	09.02.21		2.0		Mr.doob			+ Removed Player version, until I know if it's really needed.
 *											+ Added MAX value (shows Max memory used, useful to spot memory leaks)
 *											+ Reworked text system / no memory leak (original reason unknown)
 *											+ Simplified
 *	09.02.07		1.5		Mr.doob			+ onRemovedFromStage() (thx huihuicn.xu)
 *	08.12.14		1.4		Mr.doob			+ Code optimisations and version info on MOUSEOVER
 *	08.07.12		1.3		Mr.doob			+ Some speed and code optimisations
 *	08.02.15		1.2		Mr.doob			+ Class renamed to Stats (previously FPS)
 *	08.01.05		1.2		Mr.doob			+ Click changes the fps of flash (half up increases, half down decreases)
 *	08.01.04		1.1		Mr.doob			+ Shameless ripoff of Alternativa's FPS look :P
 *							Theo			+ Log shape for MEM
 *											+ More room for MS
 * 	07.12.13		1.0		Mr.doob			+ First version
 **/

package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	/**
	 * <b>Hi-ReS! Stats</b> FPS, MS and MEM, all in one.
	 */
	public class FPSgraph extends Sprite {
		private var xml:XML;

		private var text:TextField;
		private var style:StyleSheet;

		private var timer:uint;
		private var locolFps:int;
		private var ms:uint;
		private var msprev:uint;
		public var mem:Number;
		public var memmax:Number;

		private var graph:BitmapData;
		private var rectangle:Rectangle;

		private var fpsgraph:uint;
		private var memgraph:uint;
		private var memmaxgraph:uint;

		private var theme:Object = {bg: 0x000033, fps: 0xffff00, ms: 0x00ff00, mem: 0x00ffff, memmax: 0xff0070};
		
		private var homeMc : DisplayObjectContainer;
		private var togleKeyCode: uint;
		private var isOn:Boolean = false;
		private var bitmap:Bitmap;
		
		public var fps:int = 0;
		/**
		 * <b>Hi-ReS! Stats</b> FPS, MS and MEM, all in one.
		 *
		 * @param $theme         Example: { bg: 0x202020, fps: 0xC0C0C0, ms: 0x505050, mem: 0x707070, memmax: 0xA0A0A0 }
		 */
		
		//public function ($theme:Object = null):void {
		public function FPSgraph($homeMc:DisplayObjectContainer, $showOnInit:Boolean = true, $x:int = 0, $y:int = 0, $theme:Object = null, $togleKeyCode:uint = Keyboard.INSERT){
			if ($theme){
				if ($theme.bg != null)theme.bg = $theme.bg;
				if ($theme.fps != null) theme.fps = $theme.fps;
				if ($theme.ms != null) theme.ms = $theme.ms;
				if ($theme.mem != null) theme.mem = $theme.mem;
				if ($theme.memmax != null) theme.memmax = $theme.memmax;
			}
			
			this.homeMc = $homeMc;
			this.togleKeyCode = $togleKeyCode;
			this.x = $x;
			this.y = $y;


			if ($showOnInit){
				showCounter();
			}
			
			if ($togleKeyCode) {
				this.homeMc.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyUp);
			}
		}

		public function showCounter():void {

			graphics.beginFill(theme.bg);
			graphics.drawRect(0, 0, 70, 50);
			graphics.endFill();

			memmax = 0;

			xml =  <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax></xml>;

			style = new StyleSheet();
			style.setStyle("xml", {fontSize: '9px', fontFamily: 'sans', leading: '-2px'});
			style.setStyle("fps", {color: hex2css(theme.fps)});
			style.setStyle("ms", {color: hex2css(theme.ms)});
			style.setStyle("mem", {color: hex2css(theme.mem)});
			style.setStyle("memMax", {color: hex2css(theme.memmax)});

			text = new TextField();
			text.width = 70;
			text.height = 50;
			text.styleSheet = style;
			text.condenseWhite = true;
			text.selectable = false;
			text.mouseEnabled = false;
			addChild(text);

			bitmap = new Bitmap(graph = new BitmapData(70, 50, false, theme.bg));
			bitmap.y = 50;
			addChild(bitmap);

			rectangle = new Rectangle(0, 0, 1, graph.height);

			this.addEventListener(MouseEvent.CLICK, reset);
			this.homeMc.stage.addEventListener(Event.ENTER_FRAME, update);
			
			this.homeMc.addChild(this);
			isOn = true;
		}
		
		public function hideCounter():void{
			this.homeMc.stage.removeEventListener(Event.ENTER_FRAME, update);
			//trace("FPSlite.hideCounter");
			graphics.clear();
			this.removeChild(text);
			this.removeChild(bitmap);
			this.homeMc.removeChild(this);
			isOn = false;
		}
		
		private function keyUp(evt:KeyboardEvent):void {
			//trace("FPSlite.keyUp > evt : " + (evt.keyCode ==  Keyboard.HOME));
			if (evt.keyCode == this.togleKeyCode){
				if (this.isOn)
					hideCounter();
				else
					showCounter();
			}
		}
		

		private function update(e:Event):void {
			timer = getTimer();

			if (timer - 1000 > msprev){
				msprev = timer;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				memmax = memmax > mem ? memmax : mem;

				fpsgraph = Math.min(50, (locolFps / stage.frameRate) * 50);
				memgraph = Math.min(50, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
				memmaxgraph = Math.min(50, Math.sqrt(Math.sqrt(memmax * 5000))) - 2;

				graph.scroll(1, 0);

				graph.fillRect(rectangle, theme.bg);
				graph.setPixel(0, graph.height - fpsgraph, theme.fps);
				graph.setPixel(0, graph.height - ((timer - ms) >> 1), theme.ms);
				graph.setPixel(0, graph.height - memgraph, theme.mem);
				graph.setPixel(0, graph.height - memmaxgraph, theme.memmax);

				xml.fps = "FPS: " + locolFps + " / " + stage.frameRate;
				xml.mem = "MEM: " + mem;
				xml.memMax = "MAX: " + memmax;
				
				fps = locolFps;
				
				
				locolFps = 0;
			}

			locolFps++;
			
			//fps = "FPS: " + locolFps + " / " + stage.frameRate;
			
			
			
			xml.ms = "MS: " + (timer - ms);
			ms = timer;

			text.htmlText = xml;
		}

		public function reset(e:MouseEvent = null):void {
			mouseY / height > .5 ? stage.frameRate-- : stage.frameRate++;
			xml.fps = "FPS: " + locolFps + " / " + stage.frameRate;
			text.htmlText = xml;
		}

		// .. Utils

		private function hex2css(color:int):String {
			return "#" + color.toString(16);
		}
	}
}
