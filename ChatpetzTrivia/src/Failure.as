package {
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Failure {
		private var failure:FailureMC;
		private var client:ChatpetzTrivia;
		
		public function Failure(failure:FailureMC,client:ChatpetzTrivia) {
			this.failure = failure;
			this.client = client;
			
		}
		
		public function open() : void {
			failure.gotoAndPlay("open")
			failure.bPlay.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
		}
		
		private function onMouseDown(e:Event) : void {
			failure.gotoAndPlay("close");
			failure.addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
		
		private function onEnterFrame(e:Event) : void {
			if (failure.currentFrameLabel && failure.currentFrameLabel=="end") {
				client.startSession();
				failure.bPlay.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				failure.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
			}
		}
	}
}
