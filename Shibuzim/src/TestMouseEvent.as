package {
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TestMouseEvent extends Sprite {
		public function TestMouseEvent() {
			stage.addEventListener(MouseEvent.CLICK,onMouseEvent)
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent)
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent)
		}
		
		private function onMouseEvent(e:MouseEvent) : void {
			switch (e.type) {
				case MouseEvent.CLICK:
					trace("CLICK");
					break;
				case MouseEvent.MOUSE_DOWN:
					trace("DOWN");
					break;
				case MouseEvent.MOUSE_UP:
					trace("UP")
					break;
			}
		}
	}
}
