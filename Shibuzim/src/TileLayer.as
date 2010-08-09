package {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;

	/**
	 * @author roikr
	 */
	public class TileLayer extends Sprite {
		
		private var _color:uint;
		private var _shapeNum:uint;
		private var texture:Sprite;
		private var _mask:Sprite;
		private var bBlackNWhite:Boolean;
		private var xml:XML;
		
		
		private static var shapes:Array = [Shape1,Shape2,Shape3,Shape4,Shape5,Shape6,Shape7,Shape8,Shape9,Shape10,Shape11,Shape12,Shape13,
			Shape14,Shape15,Shape16,Shape17,Shape18,Shape19,Shape20,Shape21,Shape22,Shape23,Shape24,Shape25,Shape26,Shape27,Shape28,Shape29,Shape30,
			Shape31,Shape32,Shape33,Shape34,Shape35,Shape36,Shape37,Shape15_8,Shape15_9,Shape16_8,Shape16_9,Shape17_8,Shape17_9,Shape25_8,Shape25_9];
			
		private static var unusuals:Array = ["Shape15_8","Shape15_9","Shape16_8","Shape16_9","Shape17_8","Shape17_9","Shape25_8","Shape25_9"];
		
		
		public function TileLayer(shapeNum:uint,color:uint = 0,unusual:int = -1) {
			
			_shapeNum = getRealShapeNum(shapeNum,unusual);
				
			_color = color;
			var ref:Class = shapes[_shapeNum] as Class;
			var instance:Sprite = new ref();
			
			xml=<layer/>
			xml.@color=color;
			xml.@shape=shapeNum;
			
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
		
		public function get shapeNum() : uint {
			return _shapeNum;
		}
		
		
		
		public function get unusual() : int {
			var res:int = -1;
			switch (shapeNum+1) {
				case 8:
				case 9:
					res = shapeNum;
					break;
				default:
					break;
			}
			return res;
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
			return new TileLayer(_shapeNum,color);
		}
		
		
		
		public function set scale(x:Number) : void {
			var m:Matrix = new Matrix();
			m.scale( x, x );
			transform.matrix = m;
			
			var distance:Number = 0.5;
			var blur:Number = 1;
			var strength:Number = 0.25;
			
			texture.filters = [new DropShadowFilter(distance,45,0,1.0,blur,blur,strength,BitmapFilterQuality.HIGH)];
			
			
		}
		
	
		
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
		}
		
		
		public static function createShape(shapeNum:uint,unusual:int=-1) : Sprite {
			var ref:Class = shapes[getRealShapeNum(shapeNum,unusual)] as Class;
			return new ref();
		}
		
		public static function decode(xml:XML) : TileLayer {
			return new TileLayer(xml.@shape,xml.@color);
			
		}
		
		public function encode() : XML {
			return xml;
		}
		
		
	}
}
