package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TileTest extends Sprite {
		
		      
		public function TileTest() {
			addChild(new TileLayer(0,0xAA0022));
			
			//color.mask = shape;
			//shape.mask = color;
			//addChild(shape);
			
			
			/*
			var color:Sprite = new Sprite();
			circle.graphics.beginFill(0xAA0022);
			circle.graphics.drawCircle(40, 40, 40);
			addChild(circle);
			*/
			//square.blendMode = BlendMode.SCREEN;
			//circle.blendMode = BlendMode.SCREEN;
			//var baseData:BitmapData = bitmap.bitmapData;			
			//addChild(bitmap);
		}
	}
}
