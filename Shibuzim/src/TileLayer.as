package {
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	/**
	 * @author roikr
	 */
	public class TileLayer extends Sprite {
		
		private var color:uint;
		private var shapeNum:int;
		private static var shapes:Array = [Shape1,Shape2,Shape3,Shape4,Shape5,Shape6,Shape7,Shape8,Shape9,Shape10,Shape11,Shape12,Shape13,
			Shape14,Shape15,Shape16,Shape17,Shape18,Shape19,Shape20,Shape21,Shape22,Shape23,Shape24,Shape25,Shape26,Shape27,Shape28,Shape29,Shape30];
		
		
		public function TileLayer(shapeNum:int,color:uint) {
			this.color = color;
			this.shapeNum = shapeNum;
			var ref:Class = shapes[shapeNum] as Class;
			var shape:Sprite = new ref();
			var texture:TileTexture = new TileTexture(color);
			addChild(shape);
			addChild(texture);
			texture.mask = shape;
			texture.filters = [new DropShadowFilter(1.0)];
		}
	}
}
