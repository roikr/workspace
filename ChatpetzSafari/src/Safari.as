package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class Safari extends Sprite implements IChatpetzGame{
		
		private var background : Background;
		private var camera : Camera;
		
		
		private var interfaceBar:Interface;
		private var photoBitmap1:Bitmap;
		private var photoBitmap2:Bitmap;
		private var score:Number;
		private var feedback:Feedback;
		private var feedbackTimer:Timer;
		private var timer:Timer;
		private var time:int;
		
		private var album:Album;
		
		private var instruction:Instruction;
		
		private var gameManager:IGameManager;
		
		private var currentAnimal:Animal;
		private var bAnimalCalled:Boolean;
		private var bAnimalAnimated:Boolean;
		
		private var bStarted:Boolean;
		
		public function Safari() {
		
			addChild(background = new Background());
			
			addChild(interfaceBar = new Interface());
			
			score = 0;
			//interfaceBar.dtPoints.text = score.toString();
			photoBitmap1 = new Bitmap();
			photoBitmap2 = new Bitmap();
			interfaceBar.photo1.addChild(photoBitmap1);
			interfaceBar.photo2.addChild(photoBitmap2);
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			
			feedback = new Feedback();
			feedbackTimer = new Timer(1000,1);
			feedbackTimer.addEventListener(TimerEvent.TIMER,onFeedbackTimer);
			camera = new Camera(250,180,1.5,20)
			
			timer = new Timer(500,100);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete)
		}
		
		private function onPlay(e:Event) : void{
			e.stopImmediatePropagation();
			start(null);
		}
		
		public function start(manager:IGameManager) : void {
			gameManager = manager;
			//var instruction:Instruction  = (e.target as SimpleButton).parent as Instruction;
			
			//instruction = new Instruction();
			//addChild(instruction);
			//instruction.bPlay.addEventListener(MouseEvent.CLICK,onPlay);			
			//instruction.bPlay.removeEventListener(MouseEvent.CLICK,start);
			//removeChild(instruction); 
			
			//e.stopImmediatePropagation();
			
			replay();
			
		}
		
		public function replay() : void {
			addEventListener(MouseEvent.CLICK,takeSnapshot);
			
			camera.reset();
			
			if (album) {
				removeChild(album);
				album = null;
			}
			
			bStarted = true;
			
			addChild(camera);
			
			timer.reset();
			timer.start();
		}
		
		
		private function onTimer(e:TimerEvent) : void {
			if (gameManager)
				gameManager.setTime(timer.currentCount);
		}
		
		private function onTimerComplete(e:TimerEvent) : void {
			
			this.bStarted = false;
			removeEventListener(MouseEvent.CLICK,takeSnapshot);
			removeChild(camera);
			album = new PhotosAlbum();
			addChild(album);
			album.setPhotos(camera.getPhotos());
			album.bPlayAgain.addEventListener(MouseEvent.CLICK,onPlayAgain);
			
		}
		
		public function pause() : void {
			
		}
		
		public function help() : void {
			
		}
		
		public function exit() : void {
			removeEventListener(Event.ENTER_FRAME,onEnterFrame)
			feedbackTimer.stop();
		}
		
		
		
		private function onEnterFrame(e:Event) : void {
				
			
			background.update();
			
			if (bStarted) {
				var camPos:Point = new Point(stage.mouseX,stage.mouseY);
				camPos = this.globalToLocal(camPos);
				camera.x = camPos.x;
				camera.y = camPos.y;
				if (currentAnimal) {
					var p:Point = new Point (currentAnimal.x,currentAnimal.y);
					p = currentAnimal.parent.localToGlobal(p);
					//trace(p.x)
					if (p.x<1000 && !bAnimalCalled) {
						bAnimalCalled = true;
						if (gameManager)
							//gameManager.chooseAndPlayChatpetzCode(new Array(StripHolder.getAnimalCode(currentAnimal),ChatpetzCodes.SAFARI_GAME_I_CAN_SEE_YOU))
							gameManager.playChatpetzCode(StripHolder.getAnimalCode(currentAnimal))
						
					} else if (p.x<700 && !bAnimalAnimated) {
						
						currentAnimal.startAnimation();
						bAnimalAnimated = true;
					} else if (p.x<0) {
						currentAnimal = null
					}
				}
				
				if (!currentAnimal) {
					bAnimalCalled = false;
					bAnimalAnimated = false;
					currentAnimal =  background.addAnimal();
					//trace(StripHolder.getAnimalCode(currentAnimal))
				} 
				
				
				camera.look(background);	
			}
		}
		
		private function takeSnapshot(e:Event) : void {
			
			
			
			if (camera.snapshot()) {	
				var photo:Photo = camera.getPhoto(camera.getNumPhotos()-1);
				photoBitmap2.bitmapData =  photo.getBitmapData();
				if (camera.getNumPhotos() > 1 )
					photoBitmap1.bitmapData =  camera.getPhoto(camera.getNumPhotos()-2).getBitmapData();
				score += camera.getPhoto(camera.getNumPhotos()-1).getScore();
				//interfaceBar.dtPoints.text = score.toString();
				
				feedback.dtPoints.text  = photo.getScore().toString();
				feedback.gotoAndStop(photo.getFeedbackFrame());
				
				if (photo.isPerfectShot() && gameManager)
					gameManager.chooseAndPlayChatpetzCode(new Array(ChatpetzCodes.SAFARI_GAME_PERFECT_SHOT_1,ChatpetzCodes.SAFARI_GAME_PERFECT_SHOT_2))
				
				if (feedbackTimer.running) {
					feedbackTimer.reset();
				} else {
					addChild(feedback);
				}
				
				feedbackTimer.start();
				
				if (gameManager) {
					gameManager.setScore(score);
					gameManager.setStars(score/100);
				}
				
			}
		}
		
		private function onFeedbackTimer(e:TimerEvent) : void {
			removeChild(feedback);
			
			/*
			if (camera.getNumPhotos() > 5) {
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				removeEventListener(MouseEvent.CLICK,takeSnapshot);
				removeChild(camera);
				album = new PhotosAlbum();
				addChild(album);
				album.setPhotos(camera.getPhotos());
				album.bPlayAgain.addEventListener(MouseEvent.CLICK,onPlayAgain);
			}
			 * 
			 */
		}
		
		private function onPlayAgain(e:Event) : void {
			replay();
			
			
		}
		
	}
}
