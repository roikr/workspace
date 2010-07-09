package {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;

	/**
	 * @author roikr
	 */
	public class TestingGameUI extends Sprite {
		private var gameUI:GameUI;
		
		public function TestingGameUI() {
			super();
			addChild(gameUI = new GameUI(null));
			gameUI.x = -100;
			gameUI.open();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		private function onKeyDown(event:KeyboardEvent) : void {
			trace("keyDownHandler: " + event.keyCode);
            trace("ctrlKey: " + event.ctrlKey);
            trace("keyLocation: " + event.keyLocation);
            trace("shiftKey: " + event.shiftKey);
            trace("altKey: " + event.altKey);
			trace("charCode: " + event.charCode);
			switch(String.fromCharCode(event.charCode)) {
				case "1":
					gameUI.setCloudsScore(10);
					trace("1")
					break;
				case "2":
					gameUI.setCloudsScore(20);
					trace("2")
					break;
				case "3":
					gameUI.setCloudsScore(30);
					trace("3")
					break;
				case "4":
					gameUI.setCloudsScore(45);
					trace("4")
					break;
			}
		}
	}
}
