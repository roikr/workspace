package {
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Success {
		private var success:SuccessMC;
		private var client:ChatpetzTrivia;
		
		public function Success(success:SuccessMC,client:ChatpetzTrivia) {
			this.success = success;
			this.client = client;
			
		}
		
		public function open() : void {
			success.gotoAndPlay("open")
			SoundManager.playSound(TriviaSounds.OPENING_STONES_SOUND);
			success.bPlay.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
		}
		
		private function onMouseDown(e:Event) : void {
			success.gotoAndPlay("close");
			success.addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
		
		private function onEnterFrame(e:Event) : void {
			if (success.currentFrameLabel && success.currentFrameLabel=="end") {
				client.startSession();
				success.bPlay.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				success.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
			}
		}
	}
}
