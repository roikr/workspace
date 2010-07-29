package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;

	/**
	 * @author roikr
	 */
	public class TileLayer extends Sprite {
		
		private var color:uint;
		private var _shapeNum:uint;
		private var texture:Sprite;
		private var _mask:Sprite;
		private var bBlackNWhite:Boolean;
		
		private static var shapes:Array = [Shape1,Shape2,Shape3,Shape4,Shape5,Shape6,Shape7,Shape8,Shape9,Shape10,Shape11,Shape12,Shape13,
			Shape14,Shape15,Shape16,Shape17,Shape18,Shape19,Shape20,Shape21,Shape22,Shape23,Shape24,Shape25,Shape26,Shape27,Shape28,Shape29,Shape30,
			Shape31,Shape32,Shape33,Shape34,Shape35,Shape36];
		
		
		public function TileLayer(shapeNum:uint,color:uint = 0) {
			_shapeNum = shapeNum;
			this.color = color;
			var ref:Class = shapes[_shapeNum] as Class;
			var instance:Sprite = new ref();
			
			
			switch (_shapeNum+1) {
				case 29:
				case 30:
				case 33:
				case 34:
				case 35:
				case 36:
					
					bBlackNWhite = true;
					texture = instance;
					_mask = instance.getChildByName("shape") as Sprite;
					addChild(texture);
					break;
				default:
					bBlackNWhite = false;
					_mask = instance;
					texture = new TileTexture(color);
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
		
		public function setColor(color:uint) : void {
			if (texture && !bBlackNWhite) {
				removeChild(texture);
				this.color = color;
				texture = new TileTexture(color);
				addChild(texture);
				texture.addChild(_mask);
				texture.mask = _mask;
				texture.filters = [new DropShadowFilter(1.0)];
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
		
		public static function createShape(shapeNum:uint) : Sprite {
			var ref:Class = shapes[shapeNum] as Class;
			return new ref();
		}
	}
}
