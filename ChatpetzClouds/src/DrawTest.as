package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author roikr
	 */
	public class DrawTest extends Sprite {
		public function DrawTest() {
			var obj:Bowl = new Bowl();
			obj.gotoAndStop("CHSU");
			trace(obj.getBounds(obj));
			var rect:Rectangle = obj.getBounds(obj);
			var matrix:Matrix = new Matrix();
			matrix.translate(-rect.x, -rect.y);
			
			var data:BitmapData = new BitmapData(obj.width,obj.height,true,0);
			data.draw(obj,matrix);
			var bitmap:Bitmap = new Bitmap(data);
			addChild(bitmap);
		}
	}
}
