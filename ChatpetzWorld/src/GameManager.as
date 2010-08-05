package {
	import fl.containers.UILoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**
	 * @author roikr
	 */
	public class GameManager extends Sprite implements IGameManager{
		
		private var gameUI : GameUI;
		private var game:IChatpetzGame;
		private var world:ChatpetzWorld;
		private var loadingMC:LoadingMC;
		private var gameContainer:Sprite;
		
		
		public function GameManager(world:ChatpetzWorld,container:ContainerAsset) {
			super();
			this.world = world;
			gameContainer = container.spGameContainer as Sprite;
			addChild(gameUI=new GameUI(this));
			loadingMC = new LoadingMC();
		}
		
		
		public function close() : void {
			world.getBack();
		}
		
		

		
// IGameManager
		
		public function load(url:String) : void {
			gameContainer.addChild(loadingMC);
			loadingMC.mcLoadingBar.gotoAndStop(1);
			world.unloadMap();
			gameUI.open();
			//var url:String = "ChatpetzClouds.swf";
			var req:URLRequest = new URLRequest(url);
			
			var uiLoader:UILoader = new UILoader();
			uiLoader.autoLoad = false;
			uiLoader.scaleContent = false;
			uiLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			uiLoader.addEventListener(Event.COMPLETE, completeHandler);
			SoundManager.stopAllSounds();
			uiLoader.load(req);
			
			//gameInterface.bStart.enabled = false;
			//gameInterface.cbSound.selected = true;
		}

		
		public function unload() : void {
			game.exit();
			var uiLoader:UILoader = gameContainer.getChildAt(0) as UILoader;
			uiLoader.unload();
			gameContainer.removeChild(uiLoader);
			uiLoader = null;
			game = null;
		}
		
		
		
		public function setStars(stars:int) : void {
			gameUI.setCloudsScore(stars);	
		}

		public function setScore(score:int) : void {
			gameUI.setScore(score)
		}
		
		public function setLevel(level:int) : void {
			gameUI.setLevel(level);	
		}
		
		public function setTime(time:int) : void {
			gameUI.setTime(time);
		}
		
		
		

		private function progressHandler(e:ProgressEvent) : void {
			//trace("progressHandler: "+e.bytesLoaded+"/"+e.bytesTotal);
			var per:Number = e.bytesLoaded/e.bytesTotal;
			trace(per);
			loadingMC.mcLoadingBar.gotoAndStop(int(per*99)+1);
		}

		private function completeHandler(e:Event) : void {
			//gameInterface.bStart.enabled = true;
			//gameInterface.bStart.addEventListener(MouseEvent.MOUSE_DOWN,onStart);
			
			gameContainer.removeChild(loadingMC)
			
			
			
			var uiLoader:UILoader = e.currentTarget as UILoader;
			gameContainer.addChild(uiLoader);
			uiLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			uiLoader.addEventListener(Event.COMPLETE, completeHandler);
			game = uiLoader.content as IChatpetzGame;
			game.start(this);
			//gameInterface.bStart.enabled = false;
		}
		
	}
}
