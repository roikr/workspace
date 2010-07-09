package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class ChatpetzVoicesTest extends Sprite {
		
		public function ChatpetzVoicesTest():void {
			super();
			ChatpetzCodes.setTestChatpetz(true);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
		}
		
		private function onMouseDown(e:Event) : void {
			//ChatpetzCodes.play(ChatpetzCodes.WORLD_CLICK_AVATAR_1,0.5);
			ChatpetzCodes.chooseAndPlay(new Array(ChatpetzCodes.CLOUDS_GAME_TIME_ALERT_1,ChatpetzCodes.CLOUDS_GAME_TIME_ALERT_2))
		}
	}
}
