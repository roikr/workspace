package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class ShapesMenu extends Sprite {
		
		private var _shapeNum : int;
		private var client:Object;
		
		public function ShapesMenu(client:Object) {
			this.client = client;
			x = 10;
			y = 158;
			var i:int;
			for (i=0;i<14;i++) {
				graphics.beginFill(0xFF0000);
				graphics.drawRect(29*(i%5), 29*int(i/5), 26, 26)
			}
			
			for (i=0;i<14;i++) {
				graphics.beginFill(0x00FF00);
				graphics.drawRect(29*(i%5), 29*(3+int(i/5)), 26, 26)
			}
			
			for (i=0;i<8;i++) {
				graphics.beginFill(0x0000FF);
				graphics.drawRect(29*(i%4), 29*(6+int(i/4)), 26, 26)
			}
			
			//this.buttonMode  = true;
			//this.useHandCursor = true;
			this.alpha = 0.0; // TODO: alpha for shapes menu
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			var p:Point = new Point(e.localX,e.localY);
			var row:int = p.y/29;
			var column :int = p.x/29;
			
			//trace(row)
			
			if (row < 3) {
				_shapeNum =  row * 5 + column;
			} else if (row<6) {
				_shapeNum = 14 + (row-3) * 5 + column;
			} else {
				_shapeNum = 28 + (row-6) * 4 + column;
			}
			
			trace(_shapeNum+1);
			
			client.onClient(this);
		}
		
		public function get shape() : int {
			return _shapeNum;
		}
	}
}
