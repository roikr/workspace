package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class TileTest extends Sprite {
		
		public var tile:Tile ;
		public function TileTest() {
			
			var picker:ColorPicker = new ColorPicker();
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			tile = new Tile();
			//var layer:TileLayer = new TileLayer(0, 0,0);
			tile.addLayer(0,0x3355AA)
			addChild(tile);
			x = 50;
			y = 0;
			tile.scale = 0.3;
			
			
			//color.mask = shape;
			//shape.mask = color;
			//addChild(shape);
			
			
			/*
			var color:Sprite = new Sprite();
			circle.graphics.beginFill(0xAA0022);
			circle.graphics.drawCircle(40, 40, 40);
			addChild(circle);
			*/
			//square.blendMode = BlendMode.SCREEN;
			//circle.blendMode = BlendMode.SCREEN;
			//var baseData:BitmapData = bitmap.bitmapData;			
			//addChild(bitmap);
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			//trace(e.target,e.currentTarget)
			trace("hit");
			//trace(e.stageX,e.stageY,tile.testPoint(new Point(e.stageX,e.stageY)));
		}
	}
}
