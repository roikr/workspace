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
		private var shapesMenu:ShapesMenu;
		
		
		public function TileEditor() {
			x = 20;
			y = 75;
			
			addChild(bitmap)
			
			//addChild(new TilesMenu(this));
			addChild(colorPicker = new ColorPicker())
			addChild(shapesMenu = new ShapesMenu(this))
			
			addChild(tileView = new TileView());
			
			
			//tileView.x+=240;
		}
		
		public function onClient(obj:Object) : void {
			if (obj is ShapesMenu) {
				//var p:Point = new Point(e.stageX,e.stageY);
				var p:Point = this.globalToLocal(colorPicker.pos);
				var color : uint = bitmap.bitmapData.getPixel(p.x, p.y);
				tileView.addTile(shapesMenu.shape,color);
			}
		}
		
		public function onColorPick(e:MouseEvent) : void {
			
			
			
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
