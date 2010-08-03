package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class Tile extends Sprite {
		
		private var lastLayer:TileLayer = null;
		private var _scale : Number = 1;
		private var xml:XML;
		
		public function Tile() {
			mouseChildren = false;
			
		}
		
		private function getLayer(shapeNum:uint) : TileLayer {
			for (var i:int = 0;i<numChildren;i++) {
				var layer:TileLayer = getChildAt(i) as TileLayer;
				if (layer.shapeNum == shapeNum)
					return  layer
			}
			
			return null
		}
		
		public function applyLayer(shapeNum:uint,color:uint = 0) : void {
			xml = null;
			var layer:TileLayer = getLayer(shapeNum);
			if (layer) {
				removeChild(layer)
				if (layer == lastLayer) {
					if (numChildren)
						lastLayer = getChildAt(0) as TileLayer ;
					else
						lastLayer = null;
				}
			}
			else {
				var test:Sprite = new Sprite();
				var newShape:Sprite = TileLayer.createShape(shapeNum);
				test.addChild(newShape);
						
				for (var i=0;i<numChildren;i++) {
					var num:uint = (getChildAt(i) as TileLayer).shapeNum;
					var shape:Sprite = TileLayer.createShape(num);
					test.addChild(shape);
					
					if (RKUtilities.hitTest(shape,newShape)) {
						//trace(testLayer.shapeNum,newLayer.shapeNum);
						removeChild(getChildAt(i) as TileLayer);
						
					}
					test.removeChild(shape);
					
				}
				lastLayer = new TileLayer(shapeNum,color);	
				lastLayer.scale = _scale;
				addChild(lastLayer);
				
				
			}
		}
		
		public function setColor(color:uint) : void {
			if (lastLayer) {
				lastLayer.setColor(color);
			}
		}
		
		
		public function set scale(x:Number) : void {
			_scale = x;
			for (var i:int = 0;i<numChildren;i++) {
				(getChildAt(i) as TileLayer).scale=_scale;
			}
		}
		
		public function cloneTile() : Tile {
			var tile:Tile = null;
			if (numChildren) {
				tile = new Tile();
				for (var i:int = 0;i<numChildren;i++) {
					tile.addChild((getChildAt(i) as TileLayer).cloneLayer())
				}
			}
			return tile;
		}
		
		public static function decode(xml:XML) : Tile {
			var list:XMLList = xml.layer;
			var tile:Tile = new Tile();
			for each(var layer:XML in list) {
				tile.addChild(TileLayer.decode(layer));
				
			}
			
			return tile;
			
		}
		
		public function encode() : XML {
			if (xml==null) {
				xml=<tile/>
				for (var i:int=0;i<numChildren;i++) {
					xml.appendChild((getChildAt(i) as TileLayer).encode());
				}
			}
			return xml;
		}
	}
}
