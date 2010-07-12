package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * @author roikr
	 */
	public class GameUI extends GameUIAssets {
		private var gameManager:IGameManager;
		
		private var bAnimateClouds:Boolean;
		private var currentCloudsScore:int;
		private var queuedCloudsScore:int;
		private var targetCloudsScore:int;
		private var nextRemainder:int;
		private var bOpened:Boolean;
		
		
		
		public function GameUI(gameManager:IGameManager) {
			this.gameManager = gameManager ;
			bOpened = false;
		}
		
		
		private function configureListener() : void {
			
			bClose.addEventListener(MouseEvent.MOUSE_DOWN,function():void {close()});
			
			this.bHelp.addEventListener(MouseEvent.MOUSE_DOWN,onHelp);
			this.bSound.addEventListener(MouseEvent.MOUSE_DOWN,onSoundDown);
			
			
			
			bAnimateClouds = false;
			currentCloudsScore = 0;
			targetCloudsScore = 0;
			queuedCloudsScore = 0;
			
			bOpened = true;
			
			setScore(0);
			setLevel(1);
			setTime(1);
			
			
		}
		
		
		
		private function onSoundDown(e:Event) : void {
			var transform:SoundTransform = SoundMixer.soundTransform;
			transform.volume = transform.volume ? 0 : 1;
			SoundMixer.soundTransform = transform;
			
			//var wasOn:Boolean = this.bSound.mcState.currentLabel=="on";
			//SoundMixer.soundTransform = new SoundTransform(wasOn ? 0 : 1);
			//this.bSound.mcState.gotoAndStop(wasOn ? "off" : "on");
			//gameInterface.cbSound.addEventListener(Event.CHANGE, function() : void {} );
			
		}

		public function open() : void {
			
			gotoAndPlay("open");
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			this.mcLowerCreature.gotoAndStop(1);
			//this.mcUpperCreature.gotoAndStop(1);
			
		}
		
		private function close() : void {
			gotoAndPlay("close");
			bClosePanel.addEventListener(MouseEvent.MOUSE_DOWN,onClosePanel);
			if (gameManager)
				gameManager.unload();
			bOpened = false;
		}

		private function onEnterFrame(e:Event) : void {
			if (this.currentLabel=="idle") {
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				configureListener();
			}
		}
		
		private function onClosePanel(e:Event) : void {
			
			gotoAndStop(1);
			if (gameManager)
				gameManager.close();
		}
		
		
		
		private function resetClouds() : void {
			for (var i:int=0 ; i<10 ; i++) {
				var currentCloud:String = "mcC" + (i + 1).toString();
				(this.mcUpperCreature.getChildByName(currentCloud) as MovieClip).gotoAndStop("1");
				
			}
			if (bAnimateClouds) {
				bAnimateClouds = false;
				getCloudByScore(currentCloudsScore).removeEventListener(Event.ENTER_FRAME,onEnterFrameClouds);
				
			}
		}
		
		public function setCloudsScore(cloudsScore:int) : void {
			if (!bOpened)
				return;
			
			cloudsScore = cloudsScore % 31;
			if (cloudsScore < currentCloudsScore) {
				resetClouds();
				currentCloudsScore = 0;
			}
			targetCloudsScore = cloudsScore;
			if (targetCloudsScore>currentCloudsScore && !bAnimateClouds) {
				bAnimateClouds = true;
				nextRemainder = currentCloudsScore % 3+1;
				getCloudByScore(currentCloudsScore).addEventListener(Event.ENTER_FRAME,onEnterFrameClouds);
				getCloudByScore(currentCloudsScore).play();
			}
		}
		
		private function getCloudByScore(score:int) : MovieClip {
			var currentCloud:String = "mcC" + (int(score/3) + 1).toString();
			return  this.mcUpperCreature.getChildByName(currentCloud) as MovieClip;
			
		}
	
		private function updateClouds() : void {
			var lastCloud:MovieClip = getCloudByScore(currentCloudsScore);
			currentCloudsScore++;
			
			if ((currentCloudsScore == targetCloudsScore || currentCloudsScore == 31)) {
				
				lastCloud.removeEventListener(Event.ENTER_FRAME,onEnterFrameClouds);
				
				bAnimateClouds = false;
				if (currentCloudsScore % 3 > 0)
					lastCloud.stop();
				return;
				
			}
			
			
			nextRemainder = currentCloudsScore % 3+1;
			
			trace("setCloudsForAnimation: "+currentCloudsScore,targetCloudsScore);
			
			
			
			if (getCloudByScore(currentCloudsScore) != lastCloud) {
				lastCloud.removeEventListener(Event.ENTER_FRAME,onEnterFrameClouds);
				getCloudByScore(currentCloudsScore).addEventListener(Event.ENTER_FRAME,onEnterFrameClouds);
				getCloudByScore(currentCloudsScore).play();
			} 
			
		}
		
		public function onEnterFrameClouds(e:Event) : void {
			if (bAnimateClouds) {
				var mc:MovieClip = e.currentTarget as MovieClip;
				if (mc.currentLabel!=null &&  mc.currentLabel == (nextRemainder+1).toString()) {
					
					updateClouds();
				}
			}
		}

		public function setTime(time:int) : void {
			if (bOpened)
				this.mcLowerCreature.gotoAndStop(time);
		}
		
		public function setScore(score:int) : void {
			if (bOpened)
				this.mcUpperCreature.dtScore.text =  score.toString();
		}

		public function setLevel(level:int) : void {
			if (bOpened)
				this.mcLevelView.dtLevelText.text  =  level.toString();
		}
		
		public function onHelp(e:Event) : void {
			
			
		}
		
		
	}
}
