package {
	import flash.filters.BitmapFilterQuality;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class Tooltip extends Sprite {
		
		private var timer:Timer;
		private var target:Sprite;
		
		
		
		public function Tooltip(target:Sprite,text:String) {
			
			this.target = target;
			
			timer  = new Timer(1000,1);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			
			var tf:TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.background = true;
			tf.backgroundColor = 0xfef89a;
			tf.border = true;
			tf.selectable = false;
			tf.text= text;
			
			
			var shadow:DropShadowFilter =  new DropShadowFilter();
			
			shadow.strength = 0.5;
			shadow.quality = BitmapFilterQuality.HIGH;
			filters = [shadow];
			addChild(tf);
			mouseEnabled = false;
		

			target.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
		}
		
				
		
		
		public function onMouseOver(e:Event) : void {
			trace("over")
			target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			target.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			timer.start();
		}
		
		public function onMouseMove(e:Event) : void {
			trace("move")
			timer.reset();
			timer.start();
			
			
		}
		
		public function onMouseOut(e:Event) : void {
			trace("out")
			target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			target.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			timer.reset();
			
			if (this.stage)
				stage.removeChild(this);
		}
		
		
		
		public function onTimer(e:Event) : void {
			
			target.stage.addChild(this);
			x = target.stage.mouseX + 15;
			y = target.stage.mouseY + 15;
		}
		
	}
}
