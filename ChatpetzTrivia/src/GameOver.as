package {
	import flash.events.Event;

	/**
	 * @author roikr
	 */
	public class GameOver {
		private var gameOver:GameOverMC;
		private var client:ChatpetzTrivia;
		
		public function GameOver(gameOver:GameOverMC,client:ChatpetzTrivia) {
			this.gameOver = gameOver;
			this.client = client;
			
		}
		
		public function open() : void {
			gameOver.gotoAndPlay("open")
			SoundManager.playSound(TriviaSounds.OPENING_STONES_SOUND);
			gameOver.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		private function onEnterFrame(e:Event) : void {
			if (gameOver.currentFrameLabel && gameOver.currentFrameLabel=="end") {
				gameOver.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				client.endSession();
			}
		}
	}
}
