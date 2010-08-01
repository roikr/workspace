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
		
		private var tilesGrid:Grid;
		private var tileEditor:TileEditor;
		private var toolsMenu:ToolsMenu;
		
		
		
		public function TilesSimulator() {
			addChild(bitmap);
			addChild(tileEditor=new TileEditor());
			addChild(tilesGrid = new Grid(this,37,4));
			addChild(toolsMenu=new ToolsMenu(this))
			toolsMenu.tool = ToolsMenu.TOOLBAR_CURSOR;
			
		}
		
		public function onClient(obj:Object) : void {
			if (obj is ToolsMenu) {
				switch (toolsMenu.tool) {
					case (ToolsMenu.TOOLBAR_COST) : 
						trace(tilesGrid.encode().toString());
						break;
					case (ToolsMenu.TOOLBAR_INVITATION) :
						tilesGrid.undo();
						break;
				}
			}
		}

		public function cloneCurrentTile() : Sprite {
			return tileEditor.cloneCurrentTile();
		}
		
		
		
		public function get currentTool() : int {
			return toolsMenu.tool;
		}
	}
}
