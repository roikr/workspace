package {
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class Tile extends Sprite {
		
		private var _scale : Number = 1;
		private var xml:XML;
		private var _alternative: uint;
		
		public function Tile() {
			mouseChildren = false;
			_alternative = 0;
		}
		
		private function getLayer(tileLayer:TileLayer) : TileLayer {
			for (var i:int = 0;i<numChildren;i++) {
				var layer:TileLayer = getChildAt(i) as TileLayer;
				if (layer.hasSameShape(tileLayer))
					return  layer
			}
			
			return null
		}
		
		private function updateAlternative() : void {
			_alternative = 0;
			for (var i:int=0;i<numChildren;i++) {
					if (TileLayer.isAlternative(((getChildAt(i) as TileLayer).shapeNum)))
						_alternative = (getChildAt(i) as TileLayer).shapeNum;
					if (_alternative)
						break;
				}
		}
		
		public function applyLayer(tileLayer:TileLayer,color:uint = 0) : void {
			xml = null;
			var shapeNum:uint = tileLayer.shapeNum;
			var layer:TileLayer = getLayer(tileLayer);
			if (layer) {
				if (layer.color == color) 
					removeChild(layer)
				else
					layer.color = color;
				
			}
			else {
				
				
				
				updateAlternative();
				
				
				var test:Sprite = new Sprite();
				var newShape:Sprite = TileLayer.createShape(shapeNum,_alternative);
				test.addChild(newShape);
				var i:int;
				var num:int;
				var array:Array = new Array();
				
				for (i=0;i<numChildren;i++) {
					
					num = (getChildAt(i) as TileLayer).shapeNum;
					var shape:Sprite = TileLayer.createShape(num,_alternative);
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
				
				updateAlternative();
				
				
						//trace(testLayer.shapeNum,newLayer.shapeNum);
									

				var newLayer : TileLayer = new TileLayer(shapeNum,color,_alternative);	
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
				for (var i : int = 0;i < numChildren;i++) {
					tile._alternative = this._alternative;
					tile.addChild((getChildAt(i) as TileLayer).cloneLayer())
				}
			}
			return tile;
		}
		
		public static function decode(xml:XML) : Tile {
			var list : XMLList = xml.layer;
			
			var tile:Tile = new Tile();
			tile._alternative = 0;
			for each(var layer:XML in list) {
				var tileLayer:TileLayer = TileLayer.decode(layer);
				tile.addChild(tileLayer);
				if (!tile._alternative && TileLayer.isAlternative(tileLayer.shapeNum))
					tile._alternative = tileLayer.shapeNum;
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
					
				var shape:Sprite = TileLayer.createShape(layer.shapeNum,0);
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
