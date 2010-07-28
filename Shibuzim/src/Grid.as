package {
	import flash.events.MouseEvent;
	import flash.display.Sprite;

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
					graphics.beginFill(0xFFFFFF);
					graphics.drawRect((tileSize+space)*j, (tileSize+space)*i, tileSize, tileSize)
				}
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			
			var tile:Sprite = client.cloneCurrentTile();
			tile.x = int(e.localX / (tileSize+space)) * (tileSize+space);
			tile.y = int(e.localY / (tileSize+space)) * (tileSize+space);
			tile.scaleX = tile.scaleY =  tileSize / 490;
			addChild(tile);
		}
		
		
	}
}
