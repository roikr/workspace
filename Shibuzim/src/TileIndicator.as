package {
	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TileIndicator extends Sprite {
		[Embed(source='../assets/v.png')]
        private var VPNG:Class;
        private var vBitmap:Bitmap = new VPNG() ;
        
        [Embed(source='../assets/x.png')]
        private var XPNG:Class;
        private var xBitmap:Bitmap = new XPNG() ;
        
        [Embed(source='../assets/notice.png')]
        private var NoticePNG:Class;
        private var noticeBitmap:Bitmap = new NoticePNG() ;
        
        
		
		public function TileIndicator() {
			addChild(vBitmap);
			addChild(xBitmap);
			addChild(noticeBitmap);
			vBitmap.x = xBitmap.x = 137-8;
			vBitmap.y = xBitmap.y = -8;
			noticeBitmap.x = 90;
			noticeBitmap.y = 70;
			
			vBitmap.visible = false;
			xBitmap.visible = false;
			noticeBitmap.visible = false;
			
			x = 10;
			y = 10;
			
			
		}
		
		public function get completed() : Boolean {
			return vBitmap.visible;
		}
		
		public function set completed(_completed:Boolean) : void {
			vBitmap.visible = _completed;
		}
		
		public function set alert(_alert:Boolean) : void {
			xBitmap.visible = noticeBitmap.visible = _alert;
		}
		
	}
}
