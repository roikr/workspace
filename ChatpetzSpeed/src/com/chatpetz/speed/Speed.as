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
		
		private var bPrepare:Boolean; // just to know where we are onBeepCompleted
		
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
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_2);
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_3);
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_4);
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_5);
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_DOMINANT_1);
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_DOMINANT_2);
			rightAnswers.push(ChatpetzCodes.CARD_GAME_RIGHT_ANSWER_DOMINANT_3);
			
			
			wrongAnswers = new Array();
			wrongAnswers.push(ChatpetzCodes.CARD_GAME_WRONG_ANSWER_1);
			wrongAnswers.push(ChatpetzCodes.CARD_GAME_WRONG_ANSWER_2);
			wrongAnswers.push(ChatpetzCodes.CARD_GAME_WRONG_ANSWER_3);
			wrongAnswers.push(ChatpetzCodes.CARD_GAME_WRONG_ANSWER_4);
			wrongAnswers.push(ChatpetzCodes.CARD_GAME_WRONG_ANSWER_DOMINANT_1);
			wrongAnswers.push(ChatpetzCodes.CARD_GAME_WRONG_ANSWER_DOMINANT_2);
			wrongAnswers.push(ChatpetzCodes.CARD_GAME_WRONG_ANSWER_DOMINANT_3);
		}

		
		public function start(manager:IGameManager) : void {
			gameManager = manager;
			
			successes = 0;
			lastStars = 0;
			
			addChild(board = new Board(9));
			prepare();
			timer.start();
		}
		
		
		
		
		private function prepare() : void {
			board.prepare(Math.floor(9*Math.random()));
			
			//prepareTimer.start();
			bPrepare = true;
			SoundManager.playBeep(board.getAnimalCode(),this);
		}
		
		public function onBeepCompleted(obj:Object) : void {
			if (bPrepare) {
				bPrepare = false;
				board.addEventListener(MouseEvent.CLICK, onClick);
				taskTimer.start();
				board.go();
			} else {
				board.clear();
				clearTimer.start();
			}
		}
		

		private function onTaskTimer(e:TimerEvent) : void {
			board.removeEventListener(MouseEvent.CLICK, onClick);
			addChild(feedback);
			feedback.gotoAndStop(2);
			
			board.clear();
			clearTimer.start();
			
		}
		
		private function onClick(e:MouseEvent) : void {
			if (e.target is CardHolder) {
				addChild(feedback);
				
				//interfaceBar.clock.stop();
				if (board.testAnimal(e.target as CardHolder)) {
					feedback.gotoAndStop(1);
					successes++;
					score+=100;
					updateDisplay();
					SoundManager.chooseAndPlayBeep(rightAnswers,this);
					SoundManager.playSound(SpeedSounds.CARDS_WRONG_SOUND)
					setStars(successes*3);
				} else {
					feedback.gotoAndStop(3);
					SoundManager.chooseAndPlayBeep(wrongAnswers,this);
					SoundManager.playSound(SpeedSounds.CARDS_WRONG_SOUND);
					
				}
				
				board.removeEventListener(MouseEvent.CLICK, onClick);
				
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
			instruction.bPlay.addEventListener(MouseEvent.CLICK,helpDone);
		}
		
		private function helpDone(e:Event) : void {
			var instruction:Instruction  = (e.target as SimpleButton).parent as Instruction;
			instruction.bPlay.removeEventListener(MouseEvent.CLICK,start);
			removeChild(instruction); 
			
			e.stopImmediatePropagation();
		}
		
		public function exit() : void {
			
			taskTimer.reset();
			clearTimer.reset();
			timer.reset();
			SoundManager.stopMusic(SpeedSounds.SPEED_MUSIC);
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
