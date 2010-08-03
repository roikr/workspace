package {
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Intro {
		private var intro:IntroMC;
		private var client:ChatpetzTrivia;
		
		public function Intro(intro:IntroMC,client:ChatpetzTrivia) {
			this.intro = intro;
			this.client = client;
			
		}
		
		public function open() : void {
			intro.gotoAndPlay("open")
			SoundManager.playSound(TriviaSounds.OPENING_STONES_SOUND);
			intro.bPlay.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
		}
		
		private function onMouseDown(e:Event) : void {
			intro.gotoAndPlay("close");
			intro.addEventListener(Event.ENTER_FRAME, onEnterFrame)
		}
		
		private function onEnterFrame(e:Event) : void {
			if (intro.currentFrameLabel && intro.currentFrameLabel=="end") {
				client.startSession();
				intro.bPlay.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				intro.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
			}
		}
	}
}
