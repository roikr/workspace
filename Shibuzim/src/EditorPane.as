package {
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class EditorPane extends Sprite {
		
		private static const PANE_SIZE : int = 0.3*460;
		
		public function EditorPane() {
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, PANE_SIZE, PANE_SIZE);
			alpha = 0.0;
			x = 10;
			y = 10;
		}
		
		public function getCorner() : uint {
			var p:Point = new Point(stage.mouseX,stage.mouseY);
			trace(p);
			p = this.globalToLocal(p);
			
			trace(p);
			
			var i:uint = p.y>0.5*PANE_SIZE ? 1 : 0;
			var j:uint = p.x>0.5*PANE_SIZE ? 1 : 0;
			
			
			return i*2+j;  
		}
	}
}
