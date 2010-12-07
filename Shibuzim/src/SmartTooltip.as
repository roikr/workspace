package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class SmartTooltip extends Sprite {
		
		private var timer:Timer;
		private var target:Object;
		private var tf:TextField;
		private var pnt:Point;
		
		
		
		public function SmartTooltip(target:Object) {
			
			this.target = target;
			
			timer  = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			
			//var fmt:TextFormat = new TextFormat();		
			//fmt.size = 8;	
			
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.background = true;
			tf.backgroundColor = 0xfef89a;
			tf.border = true;
			tf.selectable = false;
			//tf.setTextFormat(fmt);
			
			
			
			var shadow:DropShadowFilter =  new DropShadowFilter();
			
			shadow.strength = 0.5;
			shadow.quality = BitmapFilterQuality.HIGH;
			filters = [shadow];
			addChild(tf);
			mouseEnabled = false;
		

			target.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
		}
		
				
		
		
		public function onMouseOver(e:Event) : void {
			//trace("over",e.target.y,e.currentTarget.y)
			
			target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			target.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			timer.start();
			pnt = new Point(target.stage.mouseX,target.stage.mouseY);
			
		}
		
		public function onMouseMove(e:Event) : void {
			//trace("move")
			
			timer.reset();
			timer.start();
			pnt = new Point(target.stage.mouseX,target.stage.mouseY);
		
			
		}
		
		public function onMouseOut(e:Event) : void {
			//trace("out")
			
			target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			target.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			timer.reset();
			
			if (this.stage)
				stage.removeChild(this);
		}
		
		
		
		public function onTimer(e:Event) : void {
			trace("SmartTooltip::onTimer")
			target.stage.addChild(this);
			
			tf.text = target.getTooltipText(pnt);
			
			x = pnt.x - 10 - tf.width;
			y = pnt.y + 10;
		}
		
	}
}
