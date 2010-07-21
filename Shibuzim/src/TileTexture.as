package {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TileTexture extends Sprite {
		[Embed(source='../assets/base.png')]
        private static var Base:Class;
        private static var bitmap:Bitmap = new Base() ;
		
		public function TileTexture(color:uint) {
			
			
			var base:Sprite = new Sprite();
			base.graphics.beginBitmapFill(bitmap.bitmapData);
			base.graphics.drawRect(0, 0, 495, 485);
			addChild(base);
			
			var colorLayer:Sprite = new Sprite();
			colorLayer.graphics.beginFill(color);
			colorLayer.graphics.drawRect(0,0,495,485);
			addChild(colorLayer);
			colorLayer.blendMode = BlendMode.SCREEN;
		}
	}
}
