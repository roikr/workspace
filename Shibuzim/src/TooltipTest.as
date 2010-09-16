package {
	import flash.display.Sprite;
	

	/**
	 * @author roikr
	 */
	public class TooltipTest extends Sprite {
		public function TooltipTest() {
			
			
			
			var sp1:Sprite = new Sprite;
			sp1.graphics.beginFill(0xff0000);
			sp1.graphics.drawRect(50, 50, 100, 100);
			addChild(sp1);
			new Tooltip(sp1,"red")
			
			
			
			var sp2:Sprite = new Sprite;
			sp2.graphics.beginFill(0x00ff00);
			sp2.graphics.drawRect(250, 250, 75, 25);
			addChild(sp2);
			new Tooltip(sp2,"green")
			
			
		}
	}
}
