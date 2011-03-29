package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class StreamTest extends Sprite {
		
		private var clickTimer:Timer;
		
		public function StreamTest() {
			new HighBand();
			stage.doubleClickEnabled = true;
			
			stage.addEventListener(MouseEvent.CLICK,onMouseClick);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
		}
		
		public function onMouseClick(e:Event) : void {
			clickTimer = new Timer(250,1);
			clickTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onClickTimer);
			clickTimer.start();
		}
		
		public function onClickTimer(e:Event) : void {
			new AvatarTrigger(SoundManager.mainChatpet,true,false)
			clickTimer = null;
		}
		
		
		
		public function onDoubleClick(e:Event) : void {
			if (clickTimer!=null) {
				clickTimer.stop();
				clickTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onClickTimer);
				clickTimer = null;
			}
			
			new AvatarTrigger(SoundManager.mainChatpet,true,true)
			
		}
		
		
	}
}
