package {
	import flash.events.MouseEvent;
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
		private var price:Price;
		
		
		public function TilesSimulator() {
			addChild(bitmap);
			
			addChild(tilesGrid = new Grid(this,37,4));
			addChild(toolsMenu=new ToolsMenu(this))
			
			addChild(new Tabs());
			addChild(tileEditor=new TileEditor());
			toolsMenu.tool = ToolsMenu.TOOLBAR_CURSOR;
			
		}
		
		public function onClient(obj:Object) : void {
			if (obj is ToolsMenu) {
				switch (toolsMenu.immediateTool) {
					case ToolsMenu.TOOLBAR_GRID_ERASER:
					case ToolsMenu.TOOLBAR_GRID_FILLER:
					case ToolsMenu.TOOLBAR_UNDO:
						tilesGrid.applyTool(toolsMenu.immediateTool)	
						break;
					case (ToolsMenu.TOOLBAR_COST) : 
						trace(tilesGrid.encode().toString());
						if (!price) {
							price = new Price();
							price.x = 860;
							price.y = 500;
							price.price = 34;
							addChild(price);
							price.addEventListener(MouseEvent.MOUSE_DOWN, onPrice)
						}
						break;
					case (ToolsMenu.TOOLBAR_INVITATION) :
						
						break;
				}
			}
		}
		
		private function onPrice(e:MouseEvent) : void {
			price.removeEventListener(MouseEvent.MOUSE_DOWN,onPrice);
			removeChild(price);
			price = null;
			
		}

		public function get tile() : Tile {
			return tileEditor.tile;	
		}
		
		public function set tile(tile:Tile) : void  {
			tileEditor.tile = tile;
		}
		
		
		
		public function get currentTool() : int {
			return toolsMenu.selectedTool;
		}
	}
}
