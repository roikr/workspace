package {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class Game {
		private var game:GameMC;
		private var client:ChatpetzTrivia;
		private var timer:Timer;
		
		
		public function Game(game:GameMC,client:ChatpetzTrivia) {
			this.game = game;
			this.client = client;
			timer = new Timer(2000,1);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			
		}
		
		public function open(question:int) : void {
			game.gotoAndPlay("open")
			game.bA.addEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bB.addEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bC.addEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bD.addEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bHelp.addEventListener(MouseEvent.MOUSE_DOWN,onHelp);
			game.bSkip.addEventListener(MouseEvent.MOUSE_DOWN,onSkip);
			game.mcRight.gotoAndStop(1);
			game.mcWrong.gotoAndStop(1);
			
			new QuestionSynthesizer(question,this)
			//SoundManager.playSound("QUIZ_Q1.mp3",this,true);
		}
		
		public function onFinishQuestion() : void {
			trace("finish question");
			client.onFinishQuestion();
		}
		
		private function onAnswer(e:Event) : void {
			var answer:Boolean = false;
			
			if (e.currentTarget == game.bA) {
				answer = true;
				game.mcRight.play();
			}
				
			if (e.currentTarget == game.bB) {
				game.mcWrong.play();
				answer = false;
			}
			
			client.updateScore(answer);
			timer.start();
				
			
		}
		
		private function onTimer(e:TimerEvent) : void {
			close();
		}
		
		
		
		private function onHelp(e:Event) : void {
			
		}
		
		private function onSkip(e:Event) : void {
			close();
		}
		
		public function close() : void {
			game.gotoAndPlay("close");
			game.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			game.bA.removeEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bB.removeEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bC.removeEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bD.removeEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bHelp.removeEventListener(MouseEvent.MOUSE_DOWN,onHelp);
			game.bSkip.removeEventListener(MouseEvent.MOUSE_DOWN,onSkip);
			
		}
		
		
		
		private function onEnterFrame(e:Event) : void {
			if (game.currentFrameLabel && game.currentFrameLabel=="end") {
				game.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				game.mcRight.gotoAndStop(1);
				game.mcWrong.gotoAndStop(1);
				client.nextQuestion();
				
			}
		}
	}
}
