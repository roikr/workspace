package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TileEditor extends Sprite {
		
		private var tileView:TileView;
		
		
		public function TileEditor() {
			addChild(new TilesMenu(this));
			
			addChild(tileView = new TileView());
			
			
			//tileView.x+=240;
		}
		
		public function onTileMenuDown(tileName:String) : void {
			if (tileView.doesTileExist(tileName))
				tileView.removeTile(tileName);
			else
				tileView.addTile(tileName);
		}
		
		public function cloneCurrentTile() : Sprite {
			return tileView.cloneCurrentTile();
		}
	}
}
