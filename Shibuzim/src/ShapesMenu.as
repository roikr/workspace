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
		private var shapes:ShapesPane;
		//private var _eventType:String;
		
		public function ShapesMenu(client:Object) {
			addChild(bitmap);
			addChild(shapes=new ShapesPane())
			
			this.client = client;
			x = 10;
			y = 158;
			
			
			shapes.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			
			
		}
		
		
		private function onMouseEvent(e:MouseEvent) : void {
			
			/*			
			_eventType = e.type;
			
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:
					trace("MOUSE_DOWN");
					break;
				case MouseEvent.CLICK:
					trace("CLICK")
					break;
			}
			 
			 */
			
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
		
		/*
		public function get eventType() : String {
			return _eventType;
		}
		 
		 */
		
		public function get shape() : int {
			return _shapeNum;
		}
	}
}
