package {
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Achievements extends AchievementsMC {
	
		private var client:Object;
		
		public function Achievements(client:Object) {
			this.client = client;
			achievements.bExit.addEventListener(MouseEvent.CLICK,onExit);
			gotoAndPlay("open")
		}
		
		private function onExit(e:Event) : void {
			achievements.bExit.removeEventListener(MouseEvent.CLICK,onExit);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			gotoAndPlay("close");
		}
		
		private function onEnterFrame(e:Event) : void {
			if (this.currentFrame == 1) {
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				client.exit(this); 
				
			}
		}
		
	}
}
