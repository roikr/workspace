package {
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class TileLayer extends Sprite {
				
		private var _color:uint;
		private var _shapeNum:uint;
		private var _alternative:uint;
		private var _corner:uint;
		private var texture:Sprite;
		private var _mask:Sprite;
		private var bBlackNWhite:Boolean;
		private var xml:XML;
		
		
		private static var shapes:Array = [Shape1,Shape2,Shape3,Shape4,Shape5,Shape6,Shape7,Shape8,Shape9,Shape10,Shape11,Shape12,Shape13,
			Shape14,Shape15,Shape16,Shape17,Shape18,Shape19,Shape20,Shape21,Shape22,Shape23,Shape24,Shape25,Shape26,Shape27,Shape28,Shape29,Shape30,
			Shape31,Shape32,Shape33,Shape34,Shape35,Shape36,Shape37];
			
		private static var alternatives : Array = [Shape15_8,Shape15_9,Shape16_8,Shape16_9,Shape17_8,Shape17_9,Shape25_8,Shape25_9];
			
		private static var alternativesNames:Array = ["Shape15_8","Shape15_9","Shape16_8","Shape16_9","Shape17_8","Shape17_9","Shape25_8","Shape25_9"];
		
		
		public function TileLayer(shapeNum:uint,color:uint = 0,alternative:uint = 0,corner:uint = 0) {
			
			_shapeNum = shapeNum;
			_alternative = alternative;
				
			_color = color;
			var ref:Class = getShapeClass(shapeNum,alternative);
			var instance:Sprite = new ref();
			
			xml=<layer/>
			xml.@color=color;
			xml.@shape=shapeNum;
			if (_alternative)
				xml.@alt=_alternative;
				
			if (isSpongeAlternative(_alternative) && isSpongeFiller()) {
				xml.@corner = corner;
				_corner = corner;
				
			}
				
				
				
				
			
			
			switch (_shapeNum+1) {
				case 29:
				case 30:
				case 34:
				case 35:
				case 36:
				case 37:
					
					bBlackNWhite = true;
					texture = instance;
					_mask = instance.getChildByName("shape") as Sprite;
					addChild(texture);
					break;
				default:
					bBlackNWhite = false;
					_mask = instance;
					texture = new TileTexture(ColorPicker.getColor(color));
					texture.addChild(_mask);
					addChild(texture);
				
					break;
			}
			
			texture.mask =  _mask;
			texture.filters = [new DropShadowFilter(0.5,45,0,1.0,1,1,0.25,BitmapFilterQuality.HIGH)];
			
			
		}
		
		
		
		public function get color() : uint {
			return _color;
		}
				
		public function set color(color:uint) : void {
			if (texture && !bBlackNWhite) {
				removeChild(texture);
				_color = color;
				texture = new TileTexture(ColorPicker.getColor(color));
				addChild(texture);
				texture.addChild(_mask);
				texture.mask = _mask;
				texture.filters = [new DropShadowFilter(1.0)];
				xml.@color=color;
				
			}
		}
		
		public function cloneLayer() : TileLayer {
			return new TileLayer(_shapeNum,color,_alternative,_corner);
		}
		
		public function getOffset() : Point {
			var p:Point = new Point();
			switch (_corner) {
				case 0:
				case 2:
					p.x=-120;
					break;
				case 1:
				case 3:
					p.x=120;
					break;
			}
			
			switch (_corner) {
				case 0:
				case 1:
					p.y=-120;
					break;
				case 2:
				case 3:
					p.y=120;
					break;
			}
			
			return p;
		}
		
		
		public function set scale(x:Number) : void {
			var m:Matrix = new Matrix();
			m.scale( x, x );
			
			var t:Matrix = new Matrix();
			if (isSpongeAlternative(_alternative) && isSpongeFiller()) {
						
				var p:Point = getOffset();
				t.translate(p.x, p.y)
				//trace("corner alternative",_corner,p.x,p.y)
			} 

			
			t.concat(m);	
			
			
			
			transform.matrix = t;
			
			var distance:Number = 0.5;
			var blur:Number = 1;
			var strength:Number = 0.25;
			
			texture.filters = [new DropShadowFilter(distance,45,0,1.0,blur,blur,strength,BitmapFilterQuality.HIGH)];
			
			
		}
		
	
		private static function getShapeClass(shapeNum:uint,alternative:uint) : Class {
			if (alternative) {
				switch (shapeNum+1) {
			 		case 15:
			 		case 16:
			 		case 17:
			 		case 25:
						var name:String = "Shape"+(shapeNum+1).toString()+"_"+( alternative+1).toString();
						var index:int = alternativesNames.indexOf(name);
						//trace("TileLayer::getShapeClass alternative: ",name);
						return alternatives[index] as Class;
						break;
					
					
				}
			}
			
			//trace("TileLayer::getShapeClass shape: ",shapeNum);
			return shapes[shapeNum];
		}
		
		public function get shapeNum() : uint {
			return _shapeNum;
		}
		
		public function get corner() : uint {
			return _corner;
		}
		
		public static function isAlternative(shapeNum:uint) : Boolean {
			return shapeNum+1 ==8 || shapeNum+1 == 9 || isSpongeAlternative(shapeNum);
		}
		
		public static function isSpongeAlternative(shapeNum:uint) : Boolean {
			return shapeNum+1==12 || shapeNum+1 == 13;
		}
		
		public function isSpongeFiller() : Boolean {
			return shapeNum+1>=31 && shapeNum+1 <= 33;
		}
		
		
		/*
		private static function getRealShapeNum(shapeNum:uint,unusual:int) : int {
			 var _shapeNum:int = shapeNum;
			 if (unusual != -1) {
			 	switch (shapeNum+1) {
			 		case 15:
			 		case 16:
			 		case 17:
			 		case 25:
			 			var name:String = "Shape"+(shapeNum+1).toString()+"_"+( unusual+1).toString();
						var index:int = unusuals.indexOf(name);
						_shapeNum = shapes.length - unusuals.length+index;
						trace(name," ",index,_shapeNum);
					break;
			 		
			 	}
				
			}
			return _shapeNum;
		}*/
		
		public static function createShape(shapeNum:uint,alternative:uint) : Sprite {
			var ref:Class = getShapeClass(shapeNum,alternative);
			return new  ref as Sprite;
		}
		
		/*
		public static function createShape(shapeNum:uint,unusual:int=-1) : Sprite {
			var ref:Class = shapes[getRealShapeNum(shapeNum,unusual)] as Class;
			return new ref();
		}
		 * 
		 */
		
		public static function decode(xml:XML) : TileLayer {
			var alt:uint = xml.hasOwnProperty("@alt") ? xml.@alt : 0;
			var corner:uint = xml.hasOwnProperty("@corner") ? xml.@corner : 0;
			//trace("decode: "+alt);
			return new TileLayer(xml.@shape,xml.@color,alt,corner);
			
		}
		
		public function encode() : XML {
			return xml;
		}
		
		public function isEqual(layer:TileLayer) : Boolean {
			return layer.shapeNum == shapeNum && layer.color == color;
		}
		
		public function hasSameShape(layer:TileLayer) : Boolean {
			return layer.shapeNum == shapeNum;
		}
		
		public static function canContain(shapeNum:uint) : Boolean {
			return shapeNum+1 < 15;
		}
		
		public function canContain(shapeNum:uint) : Boolean {
			switch (this.shapeNum+1) {
				case 1:
					switch (shapeNum+1) {
						case 18:
						case 19:
						case 20:
						case 21:
						case 28:
							return true;
							break;
						
					}
					break;
				case 2: 
					switch (shapeNum+1) {
						case 22:
						case 27:
						case 29:
						case 34:
						case 36:
							return true;
							break;
										
					}
					break;
				case 3: 
				case 20:
					switch (shapeNum+1) {
						case 23:
						case 26:
						case 30:
						case 35:
						case 37:
							return true;
							break;		
					}
					break;
				case 10:
					switch (shapeNum+1) {
						case 22:
						case 29:
						case 34:
						case 36:
							return true;
							break;		
					}
					break;
				case 4:
				case 12:
				case 16:
				case 19:
					return shapeNum+1 == 33
					break;
				
				case 14:
					return shapeNum+1 == 24 
					break;
				case 5:
				case 13:
				case 17:
				case 18:
				
					return  shapeNum+1 == 31 || shapeNum+1 == 32 
				
					break;
				
				case 7:
				case 8:
				case 9:
					switch (shapeNum+1) {
						case 15:
						case 16:
						case 17:
						case 25:
							return true;
							break;
					}
					break;
				
					
			}

			return false;
		}
		
		
		public function isLastPart() : Boolean {
			switch 	(shapeNum+1) {
				case 6:
				case 11:
				case 15:
					return true;
					break;
				default:
					return shapeNum+1>20
					break;			
			}
		
		}
		
		
		
		
	}
}
