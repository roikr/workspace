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
		private var xml:XML;
		private var lastXml:XML;
		
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
			
			xml = <grid/>
			lastXml = null;
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		
		
		
		private function removeTile(gridTile:GridTile) : void {
			gridTile.removeChildAt(0);
			
			delete xml.item.(@row==gridTile.y/(tileSize+space) && @column==gridTile.x/(tileSize+space))[0];
			
			//delete xml.item.("@row"==(gridTile.y/(tileSize+space)).toString() && "column"==(gridTile.x/(tileSize+space)).toString())[0]
			
		}
		
		private function applyTile(gridTile:GridTile,tile:Tile) : void {
			if (gridTile.numChildren) 
				removeTile(gridTile);
			
			//tile.x = -1;
			//tile.y = -1;
			tile.scale =  tileSize / 457;
			gridTile.addChild(tile)		
			
			var item:XML = <item/>;
			item.@row = gridTile.y / (tileSize+space);
			item.@column = gridTile.x / (tileSize+space);
			item.appendChild((gridTile.getChildAt(0) as Tile).encode());
			xml.appendChild(item);	
			
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
			applyTool(client.currentTool,e);
		}
			
		public function applyTool(tool:int,e:MouseEvent = null) : void {
			switch (tool) {
				case (ToolsMenu.TOOLBAR_CURSOR):
				case (ToolsMenu.TOOLBAR_ROW_FILLER) :
				case (ToolsMenu.TOOLBAR_COLUMN_FILLER) :
				case (ToolsMenu.TOOLBAR_GRID_FILLER) :
				case (ToolsMenu.TOOLBAR_GRID_ERASER) :
				case (ToolsMenu.TOOLBAR_TILE_ERASER) : 
					lastXml = xml.copy();
					break;
			}
			
			switch (tool) {
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
				
					clear();
					break;
					
				case (ToolsMenu.TOOLBAR_TILE_ERASER) : 
						if ((e.target as GridTile).numChildren)
							removeTile(e.target as GridTile);
							
					break;
					
				case ToolsMenu.TOOLBAR_UNDO:
					if (lastXml) {
						decode(lastXml);
						lastXml = null;
					}
					//for each (var item:XML in lastXml ) {
					//	trace (item.toString());
					//}
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
		
		
		
		public function clear() : void {
			for (var i:int=0;i<numChildren;i++) {
				if ((getChildAt(i) as GridTile).numChildren)
					removeTile(getChildAt(i) as GridTile);
			}
		}
		
		
		public function decode(xml:XML) : void{
			clear();
			for each (var item:XML in xml.item ) {
				var tile:Tile = Tile.decode(item.tile[0]);
				tile.x = -1;
				tile.y = -1;
				tile.scale =  tileSize / 450;
				var point:Point = new Point(item.@column*(tileSize+space),item.@row*(tileSize+space));
				point = this.localToGlobal(point);
				var gridTile:GridTile = getGridTileAt(point);
				gridTile.addChild(tile);
				//trace (item.toString());
			}
			this.xml = xml;
		}
		
		public function encode() : XML {
			
			/*
			var xml:XML = <grid/>
			for (var i:int=0;i<numChildren;i++) {
				var sprite:Sprite  = getChildAt(i) as Sprite;
				if (sprite.numChildren) {
					var item:XML = <item/>;
					item.@row = sprite.y / (tileSize+space);
					item.@column = sprite.x / (tileSize+space);
					item.appendChild((sprite.getChildAt(0) as Tile).encode());
					xml.appendChild(item);
				}
			}
			 
			 */
			
			return xml;
		}
		
		
	}
}
