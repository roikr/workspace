package {
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Freezer extends FreezerMC {
		
		private var client:Object;
		
		public function Freezer(client:Object) {
			this.client = client;
			fridgeInAnim.bExit.addEventListener(MouseEvent.CLICK,onExit);
			gotoAndPlay("open")
		}
		
		private function onExit(e:Event) : void {
			fridgeInAnim.bExit.removeEventListener(MouseEvent.CLICK,onExit);
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
