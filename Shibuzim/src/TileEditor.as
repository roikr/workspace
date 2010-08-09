package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class TileEditor extends Sprite {
		
		[Embed(source='../assets/editor.png')]
        private var EditorPNG:Class;
        private var bitmap:Bitmap = new EditorPNG() ;
		private var _tile:Tile;
		private var colorPicker:ColorPicker;
		private var shapesMenu:ShapesMenu;
		
		
		public function TileEditor() {
			x = 20;
			y = 75;
			
			addChild(bitmap)
			
			
		    addChild(colorPicker = new ColorPicker())
			addChild(shapesMenu = new ShapesMenu(this))
			tile = new Tile();
			
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xFF0000);
			sp.graphics.drawRect(0, 0, 0.3*460, 0.3*460);
			sp.alpha = 0.0;
			sp.x = 10;
			sp.y = 10;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			
			
			
			
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			
			var layer:TileLayer = _tile.getLayerByPoint(new Point(e.stageX,e.stageY));
			
			if (layer) {
				_tile.applyLayer(layer.shapeNum,colorPicker.color)
				//trace(layer.shapeNum)
			}
		}
		
		public function onClient(obj:Object) : void {
			if (obj is ShapesMenu) {
				//var p:Point = new Point(e.stageX,e.stageY);
				

				_tile.applyLayer(shapesMenu.shape,colorPicker.color);
			} 
			
			//else if (obj is ColorPicker) {
			//	tile.setColor(colorPicker.color)
			//}
		}
		
		
		
		
		public function get tile() : Tile {
			return _tile;
		}
		
		public function set tile(_tile:Tile) : void {
			if (this._tile) {
				this.addChildAt(_tile,getChildIndex(this._tile));
				removeChild(this._tile);
			} else
				addChild(_tile);
			
			_tile.x = 10;
			_tile.y = 10;
			_tile.scale = 0.3;
			this._tile = _tile;
		}
		
	}
}
