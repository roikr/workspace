package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * @author roikr
	 */
	public class TestingGameManager extends Sprite implements IGameManager{
		
		public var testUI : TestingGameUIAssets;
		public var game:IChatpetzGame;
		
		
		public function TestingGameManager() {
			addChild(testUI=new TestingGameUIAssets());
		}
		
		public function load(url:String) : void {
			//var url:String = "ChatpetzClouds.swf";
			var req:URLRequest = new URLRequest(url);
			testUI.uiLoader.scaleContent = false;
			testUI.uiLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			testUI.uiLoader.addEventListener(Event.COMPLETE, completeHandler);
			testUI.uiLoader.load(req);
			testUI.bStart.enabled = false;
			testUI.bClose.enabled = false;
			testUI.cbSound.selected = true;
		}
		
		public function unload() :void {
			game.exit();
			testUI.uiLoader.unload();
			game = null;
			testUI.bStart.enabled = false;	
			testUI.bClose.enabled = false;	
		}
		
		public function close() : void {
			
		}

		private function progressHandler(e:ProgressEvent) : void {
			//trace("progressHandler: "+e.bytesLoaded+"/"+e.bytesTotal);
		}
		
		private function completeHandler(e:Event) : void {
			testUI.bStart.enabled = true;
			testUI.bStart.addEventListener(MouseEvent.MOUSE_DOWN,onStart);
			testUI.bClose.addEventListener(MouseEvent.MOUSE_DOWN,onClose);
			testUI.bHelp.addEventListener(MouseEvent.MOUSE_DOWN,onHelp);
			testUI.cbSound.addEventListener(Event.CHANGE, function() : void {SoundMixer.soundTransform = new SoundTransform(testUI.cbSound.selected ? 1 : 0);} );
			game = testUI.uiLoader.content as IChatpetzGame;
		}

		private function onStart(e:Event) : void {
			e.stopImmediatePropagation();
			game.start(this);
			testUI.bStart.enabled = false;	
			testUI.bClose.enabled = true;		
		}
		
		public function onClose(e:Event) : void {
			e.stopImmediatePropagation();
			unload();
			close();
		}
		
		public function onHelp(e:Event) : void {
			e.stopImmediatePropagation();
			game.help();
		}
		
		public function setStars(stars:int) : void {
			testUI.laStars.text = stars.toString();
		}

		public function setScore(score:int) : void {
			testUI.laScore.text = score.toString();
		}
		
		public function setLevel(level:int) : void {
			testUI.laLevel.text = level.toString();
		}
		
		public function setTime(time:int) : void {
			testUI.laTime.text = time.toString();
		}
		
		public function getAvatar() : MovieClip {
			var mc:MovieClip = new MovieClip;
			mc.graphics.beginFill(0x4466AA);
			mc.graphics.drawEllipse(-50, -150, 100, 150);
			return mc
;			
		}
		
		public function onBeepCompleted(obj:Object) : void {
			
		}

	}
}
