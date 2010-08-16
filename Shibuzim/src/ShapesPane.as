package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class ShapesPane extends Sprite {
		public function ShapesPane() {
			var i:int;
			for (i=0;i<14;i++) {
				graphics.beginFill(0xFF0000);
				graphics.drawRect(29*(i%5), 29*int(i/5), 26, 26)
			}
			
			for (i=0;i<14;i++) {
				graphics.beginFill(0x00FF00);
				graphics.drawRect(29*(i%5), 29*(3+int(i/5)), 26, 26)
			}
			
			for (i=0;i<9;i++) {
				graphics.beginFill(0x0000FF);
				graphics.drawRect(29*(i%5), 29*(6+int(i/5)), 26, 26)
			}
			
			//this.buttonMode  = true;
			//this.useHandCursor = true;
			alpha = 0.0; // TODO: alpha for shapes menu
			//shapes.addEventListener(MouseEvent.CLICK,onMouseEvent);
		}
	}
}
