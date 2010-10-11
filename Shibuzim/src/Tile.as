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
		
		public function isCompleted() : Boolean {
			return numChildren && (getChildAt(numChildren-1) as TileLayer).isLastPart();
		}
		
		/*
		public function isSponge() : Boolean {
			return TileLayer.isSpongeAlternative(_alternative)
		}
		 * 
		 */
		
		public function canAdd(shapeNum:uint) : Boolean {
			for (var i:int = numChildren-1 ; i>=0 ;i--) {
				if ((getChildAt(i) as TileLayer).canContain(shapeNum)) {
					return true;
					
				}
			}
			
			return TileLayer.canContain(shapeNum);
		}
		
		public function addLayer(shapeNum:uint,color:uint) : void {
			
			
			xml = null;
			
			var i:int;
			for (i = numChildren-1 ; i>=0 ;i--) {
				if ((getChildAt(i) as TileLayer).canContain(shapeNum)) {
					/*
					if (isSponge()) {
						for (var j:int=i+1;j<numChildren;j++) {
							if ((getChildAt(j) as TileLayer).corner == corner) {
								removeChildAt(j);
								break;
							}
						}
							
					} else { */
					
					while (numChildren > i+1)
						removeChildAt(numChildren-1);
					
					/*
					if (isSponge()) {
						for (var j:int=0;j<4;j++) {
							var layer:TileLayer = new TileLayer(shapeNum,color,_alternative,j);
							layer.scale = _scale;
							addChild(layer);
						}
					} else {
					 * 
					 */
					var layer:TileLayer = new TileLayer(shapeNum,color,_alternative);
					layer.scale = _scale;
					addChild(layer);
					
					
					return;
				}
			}
			
			
				
			if (TileLayer.canContain(shapeNum)) {
				while (numChildren )
					removeChildAt(0);
					
				var layer:TileLayer = new TileLayer(shapeNum,color);
				layer.scale = _scale
				_alternative = TileLayer.isAlternative(shapeNum) ? shapeNum : 0
				addChild(layer);
				
				
			}
				
			
			
			
			
			
			
		}
		
		
/*	
		public function addLayer(tileLayer:TileLayer,color:uint) : void {
			
			xml = null;
			var shapeNum:uint = tileLayer.shapeNum;

			if (numChildren && TileLayer.size(tileLayer.shapeNum) == TileLayer.BIG_SHAPE) {
				while (numChildren)
					removeChildAt(0)
			}
				
			
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
			
			var newLayer : TileLayer = new TileLayer(shapeNum,color,_alternative);	
			newLayer.scale = _scale;
			addChild(newLayer);
			
		}
		 * 
		 */
		
		
		public function updateLayer(tileLayer:TileLayer,color:uint) : void {
			xml = null;
			
			if (tileLayer.color!=color) {
				tileLayer.color = color;
			} else if (!TileLayer.canContain(tileLayer.shapeNum)) {
				removeChild(tileLayer)
			}
			
			
			
			/*	
			var layer:TileLayer = getLayer(tileLayer);
			if (layer) {
				if (layer.color == color) 
					removeChild(layer)
				else
					layer.color = color;
				
			}
			 * 
			 */
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
					
				var shape:Sprite = TileLayer.createShape(layer.shapeNum,_alternative);
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
