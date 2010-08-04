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
				var i:int;
				var num:int;
				var array:Array = new Array();
				
				for (i=0;i<numChildren;i++) {
					
					num = (getChildAt(i) as TileLayer).shapeNum;
					var shape:Sprite = TileLayer.createShape(num);
					test.addChild(shape);
					if (RKUtilities.hitTest(shape,newShape)) 
						array.push(num);
					test.removeChild(shape);
				}
				
				for each(num in array) {
					for (var j:int;j<numChildren;j++) {
						if (num == (getChildAt(j) as TileLayer).shapeNum) {
							removeChild(getChildAt(j) as TileLayer);	
							break;
						}
					}
				}
					
				
						//trace(testLayer.shapeNum,newLayer.shapeNum);
									

				lastLayer = new TileLayer(shapeNum,color);	
				lastLayer.scale = _scale;
				addChild(lastLayer);
				
				/*
				var newLayer:TileLayer = new TileLayer(shapeNum,color);
				newLayer.scale = _scale;
				addChild(newLayer);
				for (var i:int=0;i<numChildren;i++) {
					var tempLayer:TileLayer = getChildAt(i) as TileLayer;
					if (tempLayer!=newLayer && RKUtilities.hitTest(tempLayer,newLayer)) {
						removeChild(newLayer);
						return;
					}
				}
				lastLayer = newLayer;
				 * 
				 */
				
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
