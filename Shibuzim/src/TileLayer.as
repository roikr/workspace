package {
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	/**
	 * @author roikr
	 */
	public class TileLayer extends Sprite {
		
		private var color:uint;
		private var shapeNum:int;
		private static var shapes:Array = [Shape1];
		
		
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
