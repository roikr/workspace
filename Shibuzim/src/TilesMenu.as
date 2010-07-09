package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author roikr
	 */
	public class TilesMenu extends Sprite {
		
		
		private var client:Object;
		
		public function TilesMenu(client:Object) {
			var tile1:Tile1;
			var tile2:Tile2;
			var tile3:Tile3;
			
			this.client = client;
			
			addChild(tile1=new Tile1())
			addChild(tile2=new Tile2())
			addChild(tile3=new Tile3())
			
			tile1.y+=120;
			tile2.y+=240;
			tile3.y+=360;
			
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			
			var tileName:String = getQualifiedClassName(e.target);
			trace(tileName);
			client.onTileMenuDown(tileName);
			
			
		}
	}
}
