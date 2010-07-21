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
		
		private var currentTool : int;
		
		public function TilesSimulator() {
			addChild(bitmap);
			addChild(tileEditor=new TileEditor());
			addChild(tilesGrid = new TilesGrid(this));
			addChild(toolsMenu=new ToolsMenu(this))
			tilesGrid.x+=200;
			toolsMenu.y+=600;
			currentTool = ToolsMenu.TOOLBAR_CURSOR;
		}

		public function cloneCurrentTile() : Sprite {
			return tileEditor.cloneCurrentTile();
		}
		
		public function usingTool(tool:int) : void {
			trace("usingTool " + tool);
			currentTool = tool;
		}
		
		public function getCurrentTool() : int {
			return currentTool;
		}
	}
}
