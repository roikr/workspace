package {
	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TilesSimulator extends Sprite {
		
		[Embed(source='../assets/back_ground.png')]
        private var BackgroundPNG:Class;
        private var bitmap:Bitmap = new BackgroundPNG() ;
		
		private var tilesGrid:TilesGrid;
		private var tileEditor:TileEditor;
		private var toolsMenu:ToolsMenu;
		
		
		
		public function TilesSimulator() {
			addChild(bitmap);
			addChild(tileEditor=new TileEditor());
			addChild(tilesGrid = new TilesGrid(this));
			addChild(toolsMenu=new ToolsMenu())
			toolsMenu.tool = ToolsMenu.TOOLBAR_CURSOR;
			tilesGrid.x+=200;
			
		}

		public function cloneCurrentTile() : Sprite {
			return tileEditor.cloneCurrentTile();
		}
		
		
		
		public function getCurrentTool() : int {
			return toolsMenu.tool;
		}
	}
}
