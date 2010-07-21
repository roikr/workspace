package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class TileEditor extends Sprite {
		
		[Embed(source='../assets/editor.png')]
        private var EditorPNG:Class;
        private var bitmap:Bitmap = new EditorPNG() ;
		private var tileView:TileView;
		private var colorPicker:ColorPicker;
		
		
		public function TileEditor() {
			x = 20;
			y = 75;
			
			addChild(bitmap)
			
			//addChild(new TilesMenu(this));
			addChild(colorPicker = new ColorPicker())
			colorPicker.addEventListener(MouseEvent.MOUSE_DOWN,onColorPick);
			
			addChild(tileView = new TileView());
			
			
			//tileView.x+=240;
		}
		
		public function onColorPick(e:MouseEvent) : void {
			var p:Point = new Point(e.stageX,e.stageY);
			p = this.globalToLocal(p);
			var color : uint = bitmap.bitmapData.getPixel(p.x, p.y);
			tileView.addTile(color);
			
			
		}
		
		/*
		public function onTileMenuDown(tileName:String) : void {
			if (tileView.doesTileExist(tileName))
				tileView.removeTile(tileName);
			else
				tileView.addTile(tileName);
		}
		*/
		public function cloneCurrentTile() : Sprite {
			return tileView.cloneCurrentTile();
		}
		
	}
}
