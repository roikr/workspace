package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class Customer {
		
		private var client:CustomersManager;
		private var asset:MovieClip;
		private var timer:Timer;
		private var position:Position;
		
		public function Customer(client:CustomersManager,position:Position) {
			this.client = client;
			this.asset = Math.random()>0.5 ? new SpaceShipCustomer1() : new SpaceShipCustomer2();
			position.pos.addChild(this.asset);
			asset.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			this.position = position;	
		}
		
		public function enter(str:String,time:int) : void {
			asset.gotoAndStop(1);
			asset.mcBubble.mcBowl.gotoAndStop(str);
			asset.gotoAndPlay("enter");
			
			timer = new Timer(time/100,100);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
		}
		
		private function onEnterFrame(e:Event) : void {
			if (asset.currentFrameLabel == "entered") {
				timer.start();
				//asset.stop();
				
			} else if (asset.currentFrameLabel == "left") {
				client.customerLeft(position);
				
			} else if (asset.currentFrameLabel == "land") {
				SoundManager.playSound(CloudsSounds.SPACESHIP_LAND);
			} else if (asset.currentFrameLabel == "takeoff") {
				SoundManager.playSound(CloudsSounds.SPACESHIP_TAKEOFF);
			} else if (asset.currentFrameLabel == "blob") {
				SoundManager.playSound(CloudsSounds.COMIC_BULB);
			}
			
			
		}
		
		private function onTimer(e:Event) : void {
			asset.mcBubble.mcClock.gotoAndStop(timer.currentCount);
		}
		
		private function onTimerComplete(e:Event) : void {
			asset.gotoAndPlay("leave");
			asset.mcBubble.mcSign.gotoAndPlay("x");
			SoundManager.playSound(CloudsSounds.COMIC_WRONG);
			SoundManager.playBeep(ChatpetzCodes.CLOUDS_GAME_UNSERVED, this)
			stop();
			
		}
		
		public function onBeepCompleted(obj:Object) : void {
			
		}

		public function hitTest(obj:DisplayObject) : Boolean {
			
			var result:Boolean = RKUtilities.hitTest(asset, obj);
			return result;						
		}
		
		
		public function serve(str:String) : Boolean {
			
			if (str == asset.mcBubble.mcBowl.currentFrameLabel) {
				timer.stop();
				asset.gotoAndPlay("leave");
				asset.mcBubble.mcSign.gotoAndPlay("v");
				
				return true;	
			} else
				return false;
		}
		
		public function stop() : void {
			timer.stop();
			asset.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
	
	}
}
