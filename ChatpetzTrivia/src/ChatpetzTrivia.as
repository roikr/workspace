package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class ChatpetzTrivia extends Sprite implements IChatpetzGame {
		
		public static const TRIVIA_MUSIC_A : String = "MOONIONER_01"
		
		private var gameAssets:WhoWantsGame;
		private var gameManager:IGameManager;
		
		private var intro:Intro;
		private var game:Game;
		private var failure:Failure;
		private var success:Success;
		private var gameOver:GameOver;
		
		private var corrects:int;
		
		private var timer:Timer;
		private var bFinished:Boolean;
		private var score:int;
		private var level:int;
		
		
		
		private var question:int;
		private var lastStars:int;
		
		
		public function ChatpetzTrivia() {
			
			SoundManager.setLibrary("TriviaSounds");
			SoundManager.playMusic(TRIVIA_MUSIC_A);
			
			addChild(gameAssets = new WhoWantsGame())
			gameAssets.mcLight.mouseEnabled = false;
			intro = new Intro(gameAssets.mcIntro,this);
			game = new Game(gameAssets.mcGame,this);
			failure = new Failure(gameAssets.mcFailure,this);
			success = new Success(gameAssets.mcSuccess,this);
			gameOver = new GameOver(gameAssets.mcGameOver,this);
			
			timer = new Timer(500,100);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete)
			
			
			
			question = 1;
			//start(null);
		}
		
		private function onTimer(e:TimerEvent) : void {
			if (gameManager)
				gameManager.setTime(timer.currentCount);
		}
		
		
		
		public function start(manager : IGameManager) : void {
			gameManager = manager;
			intro.open();
			score = 0;
			lastStars = 0;
			level = 1;
			if (gameManager)
				gameManager.setLevel(level);
		}
		
		public function startSession() : void {
			//trace("startSession");
			corrects= 0;
			bFinished = false;
			game.open(question);
			
		}
		
		public function onFinishQuestion() : void {
			timer.start();
		}
		
		
		
		public function updateScore(answer:Boolean) : void {
			if (answer) {
				corrects+=1;
				score+=10;
				setStars(corrects);
			}
			
			/*
			if (gameManager) {
				if (answer)
					gameManager.chooseAndPlayChatpetzCode(rightAnswers);
				else
					gameManager.chooseAndPlayChatpetzCode(wrongAnswers);
			}
			 * 
			 */
			 
			
					
			
			if (gameManager) {
				gameManager.setScore(score);
			}
				
			
		}
		
		private function setStars(stars:int) : void {
			
			
			switch (lastStars % 3 + 3 * (stars % 3)) {
				case 0:
					SoundManager.playSound(TriviaSounds.FULL_CLOUD_SOUND);
					break;
				case 1:
					SoundManager.playSound(TriviaSounds.FULL_CLOUD_SOUND);
					break;
				case 2:
					SoundManager.playSound(TriviaSounds.FULL_CLOUD_SOUND);
					break;
				case 3:
					SoundManager.playSound(TriviaSounds.CLOUD_1_3_SOUND);
					break;
				case 6:
					SoundManager.playSound(TriviaSounds.CLOUD_2_3_SOUND);
					break;
				case 7:
					SoundManager.playSound(TriviaSounds.CLOUD_1_3_SOUND);
					break;			
			}
			
			lastStars = stars;
			
			if (gameManager) {
				gameManager.setStars(stars);
			}
			
			
			
		}
		
		
		
		
		public function nextQuestion() : void {
			//trace("nextQuestion");
			question++;
			if (!bFinished)
				game.open(question); 
			else
				gameOver.open();
		}
		
		private function onTimerComplete(e:TimerEvent) : void {
			bFinished = true;
			game.close()
			
				
		}
		
		public function endSession() : void {
			timer.reset();
			if (corrects>=10) {
				level+=1;
				if (gameManager) 
					gameManager.setLevel(level);
				success.open();
			}
			 else
				failure.open();
			
		}
		
		

		public function pause() : void {
		}
		
		public function help() : void {
		}
		
		public function exit() : void {
			SoundManager.stopSound(TRIVIA_MUSIC_A);
			timer.stop();
		}
	}
}
