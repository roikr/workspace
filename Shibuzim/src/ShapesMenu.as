package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class ShapesMenu extends Sprite {
		
		[Embed(source='../assets/shapes.png')]
        private var ShapesPNG:Class;
        private var bitmap:Bitmap = new ShapesPNG() ;
		private var _shapeNum : int;
		private var client:Object;
		private var shapes:Sprite;
		
		public function ShapesMenu(client:Object) {
			addChild(bitmap);
			addChild(shapes=new Sprite())
			
			this.client = client;
			x = 10;
			y = 158;
			var i:int;
			for (i=0;i<14;i++) {
				shapes.graphics.beginFill(0xFF0000);
				shapes.graphics.drawRect(29*(i%5), 29*int(i/5), 26, 26)
			}
			
			for (i=0;i<14;i++) {
				shapes.graphics.beginFill(0x00FF00);
				shapes.graphics.drawRect(29*(i%5), 29*(3+int(i/5)), 26, 26)
			}
			
			for (i=0;i<9;i++) {
				shapes.graphics.beginFill(0x0000FF);
				shapes.graphics.drawRect(29*(i%5), 29*(6+int(i/5)), 26, 26)
			}
			
			//this.buttonMode  = true;
			//this.useHandCursor = true;
			shapes.alpha = 0.0; // TODO: alpha for shapes menu
			shapes.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
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
				_shapeNum = 28 + (row-6) * 5 + column;
			}
			
			//trace(_shapeNum+1);
			
			client.onClient(this);
		}
		
		public function get shape() : int {
			return _shapeNum;
		}
	}
}
