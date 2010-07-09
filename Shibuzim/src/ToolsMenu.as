package {
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class ToolsMenu extends Toolbar {
		
		
		public static const TOOLBAR_CURSOR:int = 0;
		public static const TOOLBAR_ERASER:int = 1;
		public static const TOOLBAR_DUPLICATE_COLUMN:int = 2;
		public static const TOOLBAR_DUPLICATE_ROW:int = 3;
		public static const TOOLBAR_SHIFT_RIGHT:int = 4;
		public static const TOOLBAR_INK: int = 5;
		public static const TOOLBAR_MAGNIFIER:int = 6;
		
		
		private var client:Object;
		
		public function ToolsMenu(client:Object) {
			this.client = client;
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			client.usingTool(e.localX / 50);
		}
	}
}
