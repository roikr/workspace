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
		private var _pane :EditorPane;
		private var client:Object;
		private var _indicator:TileIndicator;
		
		
		public function TileEditor(client:Object) {
			this.client = client;
			x = 20;
			y = 75;
			
			addChild(bitmap)
			
			
		    addChild(colorPicker = new ColorPicker())
			addChild(shapesMenu = new ShapesMenu(this))
			tile = new Tile();
			

			
			
			
			_pane = new EditorPane();
			addChild(_pane);
			_pane.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			
			_indicator = new TileIndicator();
			addChild(_indicator)
			
			
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			
			var layer:TileLayer = _tile.getLayerByPoint(new Point(e.stageX,e.stageY));
			
			if (layer) {
				_tile.updateLayer(layer,colorPicker.color)
				trace("TileEditor onMouseDown",layer.shapeNum)
			}
			
		}
		
		
		
		public function onClient(obj:Object) : void {
			if (obj is ShapesMenu) {
				//var p:Point = new Point(e.stageX,e.stageY);
				var layer:TileLayer = new TileLayer(shapesMenu.shape,colorPicker.color)
				layer.mouseEnabled = false; // TODO: I don't know why, but shape 29 makes problem without that
				layer.mouseChildren = false;
				client.onClient(layer);
				/*
				switch(shapesMenu.eventType) {
					case MouseEvent.CLICK:
						_tile.applyLayer(shapesMenu.shape,colorPicker.color);
						break;
					case MouseEvent.MOUSE_DOWN:
						client.onClient(new TileLayer(shapesMenu.shape,colorPicker.color));
						break;
				}
				 * 
				 */
				
			} 
			
			//else if (obj is ColorPicker) {
			//	tile.setColor(colorPicker.color)
			//}
		}
		
		
		
		
		public function get tile() : Tile {
			return _tile;
		}
		
		public function get pane() : EditorPane {
			return _pane;
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
			
			shapesMenu.update()
		}
		
		public function addLayer(shapeNum:uint,color:uint) : void {
			tile.addLayer(shapeNum,color);
			shapesMenu.update();	
			_indicator.completed = tile.isCompleted();
			_indicator.alert = false;
		}
		
		public function set alert(_alert:Boolean) : void {
			_indicator.alert = _alert;
		}
		
	}
}
