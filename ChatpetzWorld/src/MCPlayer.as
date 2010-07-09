package {
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class MCPlayer {
		
		private static var _client:Object;
		private static var _container:Sprite;
		
		
		public static function setContainer(container:Sprite) : void {
			_container = container;
		}
		
		public static function play(MC:MovieClip,client:Object=null,endEvent:Boolean= false) : void {
			_container.addChild(MC);
			_client = client;
			MC.gotoAndPlay(1);
			
			if (endEvent) {
				MC.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		
		public static function stop() : void {
			_container.removeChild(_container.getChildAt(0));
		}
		
		private static function onEnterFrame(e:Event) : void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			if ( mc.currentFrameLabel && mc.currentFrameLabel=="end") {
				mc.stop();
				mc.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				_container.removeChild(mc);
			}
		}
	}
}
