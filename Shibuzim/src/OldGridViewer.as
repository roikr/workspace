package {
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class OldGridViewer extends Sprite {
		
		private var rows:int;
		private var columns:int;
		private var tileSize:int;
		private var space:int;
		private var colorPicker:ColorPicker;
		
		
		public function OldGridViewer(xml:XML) {
			
			colorPicker = new ColorPicker(); // we need to instanciate the bitmapData of it
			
			
			tileSize = xml.@size;
			space = xml.@space;
			
			rows = 452 / (tileSize+space);
			columns = 619 / (tileSize+space);
			
			this.opaqueBackground = 0xf9f6ef;
			
			//y = (473 - (rows*(tileSize+space)-space))/2;
			
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
			
			decode(xml);
			
		}
		
		private function getGridTileAt(p:Point) : GridTile {
			for (var i:int=0;i<numChildren;i++) {
				var tile:GridTile = getChildAt(i) as GridTile;
				if (tile.hitTestPoint(p.x, p.y))
					return tile;
			}
			return null;
		}
		
		
		
		public function decode(xml:XML) : void{
			//clear();
			for each (var item:XML in xml.item ) {
				var tile:Tile = Tile.decode(item.tile[0]);
				//tile.x = -1;
				//tile.y = -1;
				tile.scale =  tileSize / 450;
				var point:Point = new Point(item.@column*(tileSize+space),item.@row*(tileSize+space));
				point = this.localToGlobal(point);
				var gridTile:GridTile = getGridTileAt(point);
				gridTile.addChild(tile);
				//trace (item.toString());
			}
			//this.xml = xml;
		}
	}
}
