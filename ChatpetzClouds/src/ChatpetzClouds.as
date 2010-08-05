package {
	import flash.display.MovieClip;
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
	public class ChatpetzClouds extends Sprite implements IChatpetzGame {
		
		private static const BEEP_STATE_IDLE:int = 0;
		private static const BEEP_STATE_TIME_ALERT:int = 1;
		private static const BEEP_STATE_SERVED:int = 2;
		private static const BEEP_STATE_DROP:int = 2;
		private var beepState:int;
		
		
		private var levels:XML = <levels><level number="1" item1="1" item2="0"/></levels>;
		private var assets:ChatpetzCloudsAssets;
		private var currentCloud:int;
		private var cloudsNumber:int;
		private var pipeTimer:Timer;
		private var cloudsServed: int;
		
		private var customersManager:CustomersManager;
		
		private var gameManager:IGameManager;
		private var score:int;
		private var level:int;
		private var timer:Timer;
		
		private var lastStars:int;
		
		
		
		public function ChatpetzClouds() {
			super();
		
			addChild(assets= new ChatpetzCloudsAssets());
			//assets.mcCloudClip1.buttonMode = true;
			//assets.mcCloudClip1.useHandCursor = true;
			assets.mcPipe.addEventListener(Event.ENTER_FRAME,onPipeEnterFrame);
			currentCloud = 1;
			cloudsNumber = 5;
			
			
			var i:int;
			for (i = 1;i<=cloudsNumber;i++) {
				var cloud:MovieClip = assets.getChildByName("mcCloudClip"+i.toString()) as MovieClip;
				cloud.useHandCursor = true;
				cloud.buttonMode = true;
				cloud.addEventListener(MouseEvent.MOUSE_DOWN,onIngredientDown);
			}
			
			for (i = 1;i<=4;i++) {
				var plate:MovieClip = assets.getChildByName("mcPlate"+i.toString()) as MovieClip;
				plate.useHandCursor = true;
				plate.buttonMode = true;
				plate.addEventListener(MouseEvent.MOUSE_DOWN,onPlateDown);
			}
			
			assets.mcCherry.addEventListener(MouseEvent.MOUSE_DOWN,onIngredientDown);
			assets.mcChoclate.addEventListener(MouseEvent.MOUSE_DOWN,onIngredientDown);
			assets.mcRainbow.addEventListener(MouseEvent.MOUSE_DOWN,onIngredientDown);
			assets.mcRain.addEventListener(MouseEvent.MOUSE_DOWN,onIngredientDown);
			assets.mcUmbrella.addEventListener(MouseEvent.MOUSE_DOWN,onIngredientDown);
			
			pipeTimer = new Timer(1000,1);
			pipeTimer.addEventListener(TimerEvent.TIMER,onPipeStart);
			pipeTimer.start();
			
			SoundManager.setLibrary("CloudsSounds");
			SoundManager.playMusic(CloudsSounds.CLOUDS_MUSIC);
			score = 0;
			lastStars = 0;
			level = 1;
			
			timer = new Timer(500,100);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete)
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
					SoundManager.playSound(CloudsSounds.FULL_CLOUD_SOUND);
					break;
				case 1:
					SoundManager.playSound(CloudsSounds.FULL_CLOUD_SOUND);
					break;
				case 2:
					SoundManager.playSound(CloudsSounds.FULL_CLOUD_SOUND);
					break;
				case 3:
					SoundManager.playSound(CloudsSounds.FULL_CLOUD_SOUND);
					break;
				case 6:
					SoundManager.playSound(CloudsSounds.FULL_CLOUD_SOUND);
					break;
				case 7:
					SoundManager.playSound(CloudsSounds.FULL_CLOUD_SOUND);
					break;				
			}
			
			lastStars = stars;
			
			if (gameManager) {
				gameManager.setStars(stars);
			}
			
			
			
		}
		
		
		public function onBeepCompleted(obj:Object) : void {
			switch (beepState) {
				case BEEP_STATE_TIME_ALERT: 
					break;
				case BEEP_STATE_SERVED:
					break;
				case BEEP_STATE_DROP:
					break;
			}
			
			beepState = BEEP_STATE_IDLE;
		}
		
		
		
		private function onTimer(e:TimerEvent) : void {
			updateDisplay();
			if (timer.currentCount == 90) {
				beepState = BEEP_STATE_TIME_ALERT;
				SoundManager.chooseAndPlayBeep(new Array(ChatpetzCodes.CLOUDS_GAME_TIME_ALERT_1,ChatpetzCodes.CLOUDS_GAME_TIME_ALERT_2),this);
			}
		}

		private function onTimerComplete(e:TimerEvent) : void {
			
			if (cloudsServed>=5) {
				level++;
			}
			
			cloudsServed = 0;
			
			timer.reset();
			timer.start();
			updateDisplay();
			
		}
		
		
		public function start(manager:IGameManager) : void {
			gameManager = manager;
			customersManager = new CustomersManager(this,assets);
			customersManager.start();
			
			cloudsServed = 0;
			timer.start();
			updateDisplay();
			
			//assets.dtClouds.text = cloudsServed.toString();
		}
		
		public function exit() : void {
			customersManager.stop();
			assets.mcPipe.removeEventListener(Event.ENTER_FRAME,onPipeEnterFrame);
			pipeTimer.stop();
			SoundManager.stopSound(CloudsSounds.CLOUDS_MUSIC);
			timer.stop();
		}
		
		public function help() : void {
			
		}
		
		public function pause() : void {
			
		}
		
		public function cloudServed(bOK:Boolean) : void {
			
			beepState = BEEP_STATE_SERVED;
			if (bOK) {
				cloudsServed++;
				score+=100;
				setStars(cloudsServed*3);
				updateDisplay();
				
				
				if (cloudsServed % 10 == 0) {
					SoundManager.playBeep(ChatpetzCodes.CLOUDS_GAME_SERVE_10,this);
				} else {
					SoundManager.chooseAndPlayBeep(new Array(ChatpetzCodes.CLOUDS_GAME_SERVE_1,ChatpetzCodes.CLOUDS_GAME_SERVE_2), this);
				}
				
				
			}
			else {
				SoundManager.playBeep(ChatpetzCodes.CLOUDS_WRONG_ORDER,this);
			}
				
			//assets.dtClouds.text = cloudsServed.toString();
		}
		
		private function onPipeStart(e:Event) : void {
			pipeTimer.stop();
			assets.mcPipe.gotoAndPlay("start");
		}

		private function onPipeEnterFrame(e:Event) : void {
			if ((e.target as MovieClip).currentFrameLabel == "end") {
				
				pipeTimer.delay = 500 + Math.random() * 3000;
				pipeTimer.start();
				
				var cloud:MovieClip = assets.getChildByName("mcCloudClip"+currentCloud.toString()) as MovieClip;	
				cloud.gotoAndPlay("start");
				SoundManager.playSound(CloudsSounds.CLOUD_OUT);
				cloud.visible = true;
				currentCloud = (currentCloud % cloudsNumber) + 1;
			}
			
		}
		
		
		
		private function onIngredientDown(e:MouseEvent) : void {
			
			
			var str:String = getQualifiedClassName(e.currentTarget);
			if (str=="Cloud" || str=="Rain" || str=="Rainbow")
				e.currentTarget.visible = false;
			trace(str);
			
			if(str=="Cloud")
				SoundManager.playSound(CloudsSounds.TAKE_CLOUD);
			else if(str=="Umbrella")
				SoundManager.playSound(CloudsSounds.TAKE_UMBRELLA);
			else if(str=="Rain" || str=="Rainbow")
				SoundManager.playSound(CloudsSounds.TAKE_RAIN_BOW);
			else if(str=="Cherry" || str=="Choclate")
				SoundManager.playSound(CloudsSounds.TAKE_ICECREAM);
			
			var p:Point = new Point(e.stageX,e.stageY);
			p = this.globalToLocal(p);
			
			var ingredient : Ingredient = new Ingredient(str,p);
			addChild(ingredient);
			ingredient.startDrag();
			ingredient.addEventListener(MouseEvent.MOUSE_UP, onIngredientUp)
			
		}
		
		private function onIngredientUp(e:MouseEvent) : void {
			var ingredient:Ingredient = e.currentTarget as Ingredient;
			
			
			
			if (ingredient.currentLabel=="N")
				assets.mcRain.visible = true;
			if (ingredient.currentLabel=="R")
				assets.mcRainbow.visible = true;
				
			ingredient.stopDrag();
			
			for (var i:int = 1;i<5;i++) {
				var plate:PlateAsset = assets.getChildByName("mcPlate"+i.toString()) as PlateAsset; 
				var bowl:MovieClip = plate.mcBowl; 
				
				if (RKUtilities.hitTest(bowl, ingredient)) {
					
					if(ingredient.currentLabel=="N")
						SoundManager.playSound(CloudsSounds.DROP_RAIN);
					else if(ingredient.currentLabel=="R") {
						SoundManager.playSound(CloudsSounds.DROP_RAINBOW);
						if (SoundManager.playBeep(ChatpetzCodes.CLOUDS_GAME_DROP_RAINBOW, this,0.25))
							beepState = BEEP_STATE_DROP;
					}
					else if(ingredient.currentLabel=="U") {
						SoundManager.playSound(CloudsSounds.DROP_UMBRELLA);
						if (SoundManager.playBeep(ChatpetzCodes.CLOUDS_GAME_DROP_UMBRELLA, this,0.25))
							beepState = BEEP_STATE_DROP;
						
					}
					else if(ingredient.currentLabel=="H" || ingredient.currentLabel=="S")
						SoundManager.playSound(CloudsSounds.DROP_ICECREAM);
					
					var label:String = ingredient.getNextBowlState(bowl.currentLabel);	
					if (label) {
						bowl.gotoAndPlay(label);
						break;
					}
									
				}
			}
			removeChild(ingredient);
			
			/*
			var p:Point = new Point(stage.mouseX,stage.mouseY);
			for (var i:int = 1;i<5;i++) {
				var plate:PlateAsset = assets.getChildByName("mcPlate"+i.toString()) as PlateAsset; 
				if (plate) {
					if (plate.hitTestPoint(p.x,p.y,true)) {
						var bowl:MovieClip = plate.mcBowl; //plate.getChildByName("mcBowl") as MovieClip;
						if (bowl) {
							var label:String = ingredient.getNextBowlState(bowl.currentFrameLabel);
							if (label)
								bowl.gotoAndStop(label);
							
						}
					}
				}
			}
			 * 
			 */
		}
		
		
		
		private function onPlateDown(e:MouseEvent) : void {
			
			
			var bowl:BowlImage = new BowlImage();
			var meal:String = Ingredient.getMealName((e.currentTarget.mcBowl as MovieClip).currentLabel);
			trace("meal name: "+meal);
			bowl.gotoAndStop(meal);
			e.currentTarget.play();
			
			var p1:Point = new Point(e.localX,e.localY);
			
			//trace(p1);
			
			var p2:Point = new Point(e.stageX,e.stageY);
			//trace(p2);
			p2 = this.globalToLocal(p2);
			//trace(p2);
			p2 = p2.subtract(p1);
			
			bowl.x = p2.x;
			bowl.y = p2.y;
			addChild(bowl);
			bowl.startDrag();
			bowl.addEventListener(MouseEvent.MOUSE_UP, onBowlUp)
			 
			
		}
		
		private function onBowlUp(e:MouseEvent) : void {
			var bowl:BowlImage = e.currentTarget as BowlImage;
			bowl.stopDrag();
			
			customersManager.test(bowl);
			
			removeChild(bowl);
		}
		
		
		
	}
}
