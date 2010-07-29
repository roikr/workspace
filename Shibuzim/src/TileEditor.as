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
		private var tile:Tile;
		private var colorPicker:ColorPicker;
		private var shapesMenu:ShapesMenu;
		
		
		public function TileEditor() {
			x = 20;
			y = 75;
			
			addChild(bitmap)
			
			//addChild(new TilesMenu(this));
			addChild(colorPicker = new ColorPicker(this))
			addChild(shapesMenu = new ShapesMenu(this))
			
			addChild(tile = new Tile());
			tile.x = 6;
			tile.y = 6;
			tile.scale = 0.3;
			//tile.scaleX = 0.3;
			//tile.scaleY = 0.3;
			
			
			//tileView.x+=240;
		}
		
		public function onClient(obj:Object) : void {
			if (obj is ShapesMenu) {
				//var p:Point = new Point(e.stageX,e.stageY);
				

				tile.applyLayer(shapesMenu.shape,colorPicker.color);
			} else if (obj is ColorPicker) {
				tile.setColor(colorPicker.color)
			}
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
			return tile.cloneTile();
		}
		
	}
}
