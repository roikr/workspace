package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class EditorPane extends Sprite {
		public function EditorPane() {
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, 0.3*460, 0.3*460);
			alpha = 0.0;
			x = 10;
			y = 10;
		}
	}
}
