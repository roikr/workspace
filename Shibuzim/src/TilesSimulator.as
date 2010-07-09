package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TilesSimulator extends Sprite {
		private var tilesGrid:TilesGrid;
		private var tileEditor:TileEditor;
		private var toolsMenu:ToolsMenu;
		
		private var currentTool : int;
		
		public function TilesSimulator() {
			addChild(tileEditor=new TileEditor());
			addChild(tilesGrid = new TilesGrid(this));
			addChild(toolsMenu=new ToolsMenu(this))
			tilesGrid.x+=120;
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
