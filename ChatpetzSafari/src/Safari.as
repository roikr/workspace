package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author roikr
	 */
	public class Safari extends Sprite implements IChatpetzGame{
		
		private static const BEEP_STATE_IDLE:int = 0;
		private static const BEEP_STATE_CALL:int = 1;
		private static const BEEP_STATE_FEEDBACK:int = 2;
		private var beepState:int;
		
		private var background : Background;
		private var camera : Camera;
		
		
		private var interfaceBar:Interface;
		private var photoBitmap1:Bitmap;
		//private var photoBitmap2:Bitmap;
		private var score:Number;
		private var feedback:Feedback;
		private var feedbackTimer:Timer;
		private var timer:Timer;
		
		
		private var album:Album;
		
		private var instruction:Instruction;
		
		private var gameManager:IGameManager;
		
		private var currentAnimal:Animal;
		private var bAnimalCalled:Boolean;
		private var bAnimalAnimated:Boolean;
		
		private var bStarted:Boolean;
		
		private var lastStars: int;
		
		public function Safari() {
			SoundManager.setLibrary("SafariSounds");
			SoundManager.playMusic(SafariSounds.SAFARI_MUSIC);
			addChild(background = new Background());
			
			addChild(interfaceBar = new Interface());
			
			score = 0;
			//interfaceBar.dtPoints.text = score.toString();
			photoBitmap1 = new Bitmap();
			//photoBitmap2 = new Bitmap();
			interfaceBar.photo1.addChild(photoBitmap1);
			//interfaceBar.photo2.addChild(photoBitmap2);
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			
			feedback = new Feedback();
			feedbackTimer = new Timer(1000,1);
			feedbackTimer.addEventListener(TimerEvent.TIMER,onFeedbackTimer);
			camera = new Camera(250,180,1.5,20)
			
			timer = new Timer(500,100);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete)
		}
		
		/*
		private function onPlay(e:Event) : void{
			e.stopImmediatePropagation();
			start(null);
		}
		 * 
		 */
		
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
			
			lastStars = 0;
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
			timer.stop();
			SoundManager.stopSound(SafariSounds.SAFARI_MUSIC);
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
					var layer:Sprite = currentAnimal.parent as Sprite;
					p = layer.localToGlobal(p);
					p = this.globalToLocal(p);
					//trace(p.x)
					var code:int = StripHolder.getAnimalCode(currentAnimal);
					var beepDistance:int = background.currentLayer.velocity*25* Beep.getDuration(code) / 1000; //  layer velocity [pixel/frame]
					//trace(getQualifiedClassName(currentAnimal)+", x: "+p.x+", distance: " +beepDistance)
					if (p.x - beepDistance  < 890-150 && !bAnimalCalled) { 
						bAnimalCalled = true;
						SoundManager.playBeep(	code, this)
						beepState = BEEP_STATE_CALL;
						
					/*	
					} else if (p.x<700 && !bAnimalAnimated) {
						
						currentAnimal.startAnimation();
						bAnimalAnimated = true;
						 
					*/
					} else if (p.x<0) {
						currentAnimal = null
					}
				}
				
				if (!currentAnimal && beepState == BEEP_STATE_IDLE) {
					bAnimalCalled = false;
					bAnimalAnimated = false;
					currentAnimal =  background.addAnimal();
					//trace(StripHolder.getAnimalCode(currentAnimal))
				} 
				
				
				camera.look(background);	
			}
		}
		
		public function onBeepCompleted(obj:Object) : void {
			switch (beepState) {
				case BEEP_STATE_CALL: 
					currentAnimal.startAnimation();
					break;
			}
			
			beepState = BEEP_STATE_IDLE;
		}

		private function takeSnapshot(e:Event) : void {
			
			
			
			if (camera.snapshot()) {	
				var photo:Photo = camera.getPhoto(camera.getNumPhotos()-1);
				photoBitmap1.bitmapData =  photo.getBitmapData();
				//if (camera.getNumPhotos() > 1 )
					//photoBitmap1.bitmapData =  camera.getPhoto(camera.getNumPhotos()-2).getBitmapData();
				score += camera.getPhoto(camera.getNumPhotos()-1).getScore();
				//interfaceBar.dtPoints.text = score.toString();
				
				//feedback.dtPoints.text  = photo.getScore().toString();
				feedback.gotoAndStop(photo.getFeedbackFrame());
				
				if (photo.isPerfectShot()) {
					beepState = BEEP_STATE_FEEDBACK;
					SoundManager.chooseAndPlayBeep(new Array(ChatpetzCodes.SAFARI_GAME_PERFECT_SHOT_1,ChatpetzCodes.SAFARI_GAME_PERFECT_SHOT_2)	, this);
					SoundManager.playSound(SafariSounds.RIGHT_SOUND);	
				}
				
				if (photo.getFeedbackFrame() == 4) {
					SoundManager.playSound(SafariSounds.WRONG1_SOUND);
				}
					
				
				if (feedbackTimer.running) {
					feedbackTimer.reset();
				} else {
					addChild(feedback);
				}
				
				feedbackTimer.start();
				
				setStars(score/50);
				
				if (gameManager) {
					gameManager.setScore(score);
					
				}
				
			}
		}
		
		private function setStars(stars:int) : void {
			
			
			switch (lastStars % 3 + 3 * (stars % 3)) {
				case 0:
					SoundManager.playSound(SafariSounds.FULL_CLOUD_SOUND);
					break;
				case 1:
					SoundManager.playSound(SafariSounds.FULL_CLOUD_2_3_SOUND);
					break;
				case 2:
					SoundManager.playSound(SafariSounds.FULL_CLOUD_1_3_SOUND);
					break;
				case 3:
					SoundManager.playSound(SafariSounds.CLOUD_1_3_SOUND);
					break;
				case 6:
					SoundManager.playSound(SafariSounds.CLOUD_2_3_SOUND);
					break;
				case 7:
					SoundManager.playSound(SafariSounds.CLOUD_1_3_SOUND);
					break;				
			}
			
			lastStars = stars;
			
			if (gameManager) {
				gameManager.setStars(stars);
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
			e.stopImmediatePropagation();
			album.bPlayAgain.removeEventListener(MouseEvent.CLICK,onPlayAgain);
			replay();
			
			
		}
		
	}
}
