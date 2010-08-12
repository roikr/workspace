package {
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class Tile extends Sprite {
		
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
				if (layer.color == color) 
					removeChild(layer)
				else
					layer.color = color;
				
			}
			else {
				var unusual:int = -1;
				for (i=0;i<numChildren;i++) {
					unusual = (getChildAt(i) as TileLayer).unusual;
					if (unusual!=-1)
						break;
				}
				
				
				var test:Sprite = new Sprite();
				var newShape:Sprite = TileLayer.createShape(shapeNum,unusual);
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
							removeChild(getChildAt(j) as TileLayer)	
							break;
						}
					}
				}
				
				for (i=0;i<numChildren;i++) {
					unusual = (getChildAt(i) as TileLayer).unusual;
					if (unusual!=-1)
						break;
				}
					
				
						//trace(testLayer.shapeNum,newLayer.shapeNum);
									

				var newLayer : TileLayer = new TileLayer(shapeNum,color,unusual);	
				newLayer.scale = _scale;
				addChild(newLayer);
				
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
		
		public function getLayerByPoint(pnt:Point) : TileLayer {
		
			for (var i:int = 0;i<numChildren;i++) {
				
				var layer:TileLayer = getChildAt(i) as TileLayer;
				
				
				
				var shape:Sprite = TileLayer.createShape(layer.shapeNum);
				stage.addChild(shape);	
				var p:Point = layer.globalToLocal(pnt);
				var hit:Boolean = shape.hitTestPoint(p.x,p.y,true);
				stage.removeChild(shape);
				if (hit)
					return layer;
				
			}
			return null;
			
		}
		
		public function isEqual(tile:Tile) : Boolean {
			if (tile.numChildren != numChildren)
				return false;
				
			for (var i:int = 0;i<numChildren;i++) {
				for (var j:int = 0;j<numChildren;j++) {
					if ((getChildAt(i) as TileLayer).isEqual(tile.getChildAt(j) as TileLayer)) 
						break;
				}
				if (j==numChildren)
					return false;
			}
			return true;
		}
		
		
	}
}
