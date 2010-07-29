package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class Grid extends Sprite {
		private var rows:int;
		private var columns:int;
		private var tileSize:int;
		private var space:int;
		private var client:Object;
		
		public function Grid(client:Object,tileSize:int,space:int) {
			this.client = client;
			rows = 452 / (tileSize+space);
			columns = 619 / (tileSize+space);
			this.tileSize = tileSize;
			this.space = space;
			
			x = 209;
			y = 75 + (473 - (rows*(tileSize+space)-space))/2;
			
			for (var i:int=0;i<rows;i++) {
				for (var j:int=0;j<columns;j++) {
					var gridTile:GridTile = new GridTile(tileSize);
					
					
					gridTile.x = (tileSize+space)*j
					gridTile.y = (tileSize+space)*i
					gridTile.mouseChildren = false;
					addChild(gridTile);
					
					//graphics.drawRect((tileSize+space)*j, (tileSize+space)*i, tileSize, tileSize)
				}
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		public function applyTile(gridTile:GridTile,tile:Tile) : void {
			if (gridTile.numChildren) 
				gridTile.removeChildAt(0);
			
			tile.x = -1;
			tile.y = -1;
			tile.scale =  tileSize / 450;
			gridTile.addChild(tile)			
		}
		
		private function getGridTileAt(p:Point) : GridTile {
			for (var i:int=0;i<numChildren;i++) {
				var tile:GridTile = getChildAt(i) as GridTile;
				if (tile.hitTestPoint(p.x, p.y))
					return tile;
			}
			return null;
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			
			switch (client.currentTool) {
				case (ToolsMenu.TOOLBAR_CURSOR):
					var tile:Tile = client.cloneCurrentTile();
					if (tile) 
						applyTile(e.target as GridTile,tile)
					break;
					
				case (ToolsMenu.TOOLBAR_ROW_FILLER) :
				
					if (client.cloneCurrentTile()) {
						for (var i:int = 0;i<columns;i++) {
						
							var p:Point = new Point(i*(tileSize+space),0);
							p = this.localToGlobal(p);
							p.y = e.stageY; 
							applyTile(getGridTileAt(p),client.cloneCurrentTile());
						}
					}
					break;
					
				case (ToolsMenu.TOOLBAR_COLUMN_FILLER) :
				
					if (client.cloneCurrentTile()) {
						for (var i:int = 0;i<rows;i++) {
							var p:Point = new Point(0,i*(tileSize+space));
							p = this.localToGlobal(p);
							p.x = e.stageX; 
							applyTile(getGridTileAt(p),client.cloneCurrentTile());
						}
					}
					break;
					
				case (ToolsMenu.TOOLBAR_GRID_FILLER) :
				
					if (client.cloneCurrentTile()) {
						for (var i:int=0;i<numChildren;i++) {
							applyTile(getChildAt(i) as GridTile,client.cloneCurrentTile());
						}
					}
					break;
					
				case (ToolsMenu.TOOLBAR_GRID_ERASER) :
				
					for (var i:int=0;i<numChildren;i++) {
						if ((getChildAt(i) as GridTile).numChildren)
							(getChildAt(i) as GridTile).removeChildAt(0);
						
					}
					break;
					
				case (ToolsMenu.TOOLBAR_TILE_ERASER) : 
						if ((e.target as GridTile).numChildren)
							(e.target as GridTile).removeChildAt(0);
					break;
					
			
					
				
				
			
			}
			/*
			if (e.target is Grid) {
				var tile:Tile = client.cloneCurrentTile();
				if (tile) {
					tile.x = int(e.localX / (tileSize+space)) * (tileSize+space)-1;
					tile.y = int(e.localY / (tileSize+space)) * (tileSize+space)-1;
					tile.scale =  tileSize / 450;
					addChild(tile);
				}
			}
			 
			 */
		}
		
		
	}
}
