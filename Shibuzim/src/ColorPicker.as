package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class ColorPicker extends Sprite {
		public function ColorPicker() {
			x = 12;
			y = 393;
			for (var i:int=0;i<5;i++) {
				for (var j:int=0;j<10;j++) {
					graphics.beginFill(0xFF0000);
					graphics.drawRect(14*j, 14*i, 10, 10)
				}
			}
			//this.buttonMode  = true;
			//this.useHandCursor = true;
			this.alpha = 0;
		}
	}
}
