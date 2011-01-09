package com.chatpetz.speed {
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author roikr
	 */
	public class Speed extends Sprite implements IChatpetzGame {
		private static const BEEP_STATE_IDLE:int = 0;
		private static const BEEP_STATE_PREPARE:int = 1;
		private static const BEEP_STATE_TOUCH:int = 2;
		private var beepState:int;
		
		private var gameManager:IGameManager;
		private var board : Board;
		
		//private var interfaceBar:Interface;
		private var photoBitmap1:Bitmap;
		private var photoBitmap2:Bitmap;
		private var score:int;
		private var feedback:Feedback;
		private var clearTimer:Timer;
		private var taskTimer:Timer;
		private var level:int;
		private var successes : int;
		private var timer:Timer;
		private var rightAnswers:Array;
		private var wrongAnswers:Array;
		
		
		
		private var lastStars:int;
		
		public function Speed() {
			SoundManager.setLibrary("SpeedSounds");
			SoundManager.playMusic(SpeedSounds.SPEED_MUSIC);
			
			addChild(new Background());
			//addChild(interfaceBar = new Interface());
			
			score = 0;
			level = 1;
			//interfaceBar.dtPoints.text = score.toString();
			photoBitmap1 = new Bitmap();
			photoBitmap2 = new Bitmap();
			//interfaceBar.photo1.addChild(photoBitmap1);
			//interfaceBar.photo2.addChild(photoBitmap2);
			
			
			 
			feedback = new Feedback();
			
			
			
				
			clearTimer = new Timer(750,1);
			clearTimer.addEventListener(TimerEvent.TIMER,onClear);
			
			taskTimer = new Timer(4000,1);
			taskTimer.addEventListener(TimerEvent.TIMER,onTaskTimer);
			
			timer = new Timer(610,100);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete)
			
			rightAnswers = new Array();
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_1);
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_5);
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_DOMINANT_1);
					
			
			wrongAnswers = new Array();
			wrongAnswers.push(ChatpetzCodes.CARD_GAME_WRONG_ANSWER_1);
			wrongAnswers.push(ChatpetzCodes.CARD_GAME_WRONG_ANSWER_DOMINANT_1);
		}

		
		public function start(manager:IGameManager) : void {
			gameManager = manager;
			beepState = BEEP_STATE_IDLE;
			
			successes = 0;
			lastStars = 0;
			
			addChild(board = new Board(9));
			prepare();
			timer.start();
		}
		
		
		
		
		private function prepare() : void {
			board.prepare(Math.floor(9*Math.random()));
			
			//prepareTimer.start();
			
			SoundManager.playBeep(board.getAnimalCode(),this);
			beepState = BEEP_STATE_PREPARE; 
		}
		
		public function onBeepCompleted(obj:Object) : void {
			switch (beepState) {
				case BEEP_STATE_PREPARE:
				
					board.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					taskTimer.start();
					board.go();
					break;
				case BEEP_STATE_TOUCH:
			
					board.clear();
					clearTimer.start();
					break;
			}
			
			beepState = BEEP_STATE_IDLE;
		}

		
		private function onTaskTimer(e:TimerEvent) : void {
			board.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addChild(feedback);
			feedback.gotoAndStop(2);
			
			board.clear();
			clearTimer.start();
			
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			if (e.target is CardHolder) {
				addChild(feedback);
				
				beepState = BEEP_STATE_TOUCH;
				//interfaceBar.clock.stop();
				if (board.testAnimal(e.target as CardHolder)) {
					feedback.gotoAndStop(1);
					successes++;
					score+=100;
					updateDisplay();
					
					SoundManager.chooseAndPlayBeep(rightAnswers,this);
					setStars(successes*3);
				} else {
					feedback.gotoAndStop(3);
					SoundManager.chooseAndPlayBeep(wrongAnswers,this);
					SoundManager.playSound(SpeedSounds.CARDS_WRONG_SOUND);
					
				}
				
				board.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				
				taskTimer.stop();
				
				
			} 
				
		}
		
		
		
		
		
		private function onClear(e:TimerEvent) : void {
			removeChild(feedback);
			prepare();
			
		}
		
		
		private function onTimerComplete(e:TimerEvent) : void {
			
			if (successes>=10) {
				level++;
			}
			
			successes = 0;
			
			timer.reset();
			timer.start();
			updateDisplay();
			
		}
		
		
		
		public function pause() : void {
			
		}
		
		public function help() : void {
			var instruction:Instruction = new Instruction();
			addChild(instruction);
			instruction.bPlay.addEventListener(MouseEvent.MOUSE_DOWN,helpDone);
		}
		
		private function helpDone(e:Event) : void {
			var instruction:Instruction  = (e.target as SimpleButton).parent as Instruction;
			instruction.bPlay.removeEventListener(MouseEvent.MOUSE_DOWN,start);
			removeChild(instruction); 
			
			e.stopImmediatePropagation();
		}
		
		public function exit() : void {
			beepState = BEEP_STATE_IDLE;
			taskTimer.reset();
			clearTimer.reset();
			timer.reset();
			SoundManager.stopSound(SpeedSounds.SPEED_MUSIC);
		}
		
		private function onTimer(e:TimerEvent) : void {
			updateDisplay();
			//if (timer.currentCount == 90) 
			//	chooseAndPlay(new Array(ChatpetzCodes.CLOUDS_GAME_TIME_ALERT_1,ChatpetzCodes.CLOUDS_GAME_TIME_ALERT_2));
		}
		
		private function updateDisplay() : void {
			if (gameManager) {
				gameManager.setLevel(level);
				gameManager.setScore(score);
				
				gameManager.setTime(timer.currentCount);
			}
			
			
		}
		
		private function setStars(stars:int) : void {
			
			
			switch (lastStars % 3 + 3 * (stars % 3)) {
				case 0:
					SoundManager.playSound(SpeedSounds.FULL_CLOUD_SOUND);
					break;
				case 1:
					SoundManager.playSound(SpeedSounds.FULL_CLOUD_SOUND);
					break;
				case 2:
					SoundManager.playSound(SpeedSounds.FULL_CLOUD_SOUND);
					break;
				case 3:
					SoundManager.playSound(SpeedSounds.FULL_CLOUD_SOUND);
					break;
				case 6:
					SoundManager.playSound(SpeedSounds.FULL_CLOUD_SOUND);
					break;
				case 7:
					SoundManager.playSound(SpeedSounds.FULL_CLOUD_SOUND);
					break;			
			}
			
			lastStars = stars;
			
			if (gameManager) {
				gameManager.setStars(stars);
			}
			
			
			
		}
		
		
		
	}
}
