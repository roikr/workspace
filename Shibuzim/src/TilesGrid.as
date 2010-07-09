package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author roikr
	 */
	public class TilesGrid extends Sprite {
		
		private var copyColumn:int = -1;
		private var copyRow :int = -1;
	
		
		private var client:TilesSimulator;
		
		public function TilesGrid(client:TilesSimulator) {
			this.client = client;
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			graphics.beginFill(0x2222FF,0.3)
			graphics.drawRect(0, 0, 840, 600)
			graphics.endFill();
		}
		
		private function getTileAt(p:Point) : Sprite {
			var sp:Sprite;
			for (var i:int = 0;i<numChildren;i++) {
				sp = getChildAt(i) as Sprite;
				if (p.x>=sp.x && p.x<=sp.x+120 && p.y>=sp.y && p.y<=sp.y+120 )
					break;
			}
			
			//trace(i<numChildren ? "tile exist": "tile does not exist")
			
			return i<numChildren ? sp : null;
		}
		
		private function cloneTile(tile:Sprite) : Sprite {
			var sp:Sprite = new Sprite();
			for (var i:int = 0; i<tile.numChildren;i++) {
				var Ref:Class = getDefinitionByName(getQualifiedClassName(tile.getChildAt(i))) as Class;
				//trace(describeType(Ref));
				sp.addChild(new Ref() as Sprite);
			}
			return sp;
		}
		
		
		private function duplicateRow(src:int,dest:int) : void{
			if (src==dest)
				return;
			var sp:Sprite;
			var i:int;
			for (i = 0;i<numChildren;i++) {
				sp = getChildAt(i) as Sprite;
				if (dest==int(sp.y/120) )
					removeChild(sp)
			}
			
			for (i = 0;i<numChildren;i++) {
				sp = getChildAt(i) as Sprite;
				if (src==int(sp.y/120) ) {
					var temp:Sprite = cloneTile(sp);
					temp.y = dest * 120;
					temp.x = sp.x;
					addChild(temp);
					
				}
			}
		}
		
		private function duplicateColumn(src:int,dest:int) : void{
			if (src==dest)
				return;
			var sp:Sprite;
			var i:int;
			for (i = 0;i<numChildren;i++) {
				sp = getChildAt(i) as Sprite;
				if (dest==int(sp.x/120) )
					removeChild(sp)
			}
			
			for (i = 0;i<numChildren;i++) {
				sp = getChildAt(i) as Sprite;
				if (src==int(sp.x/120) ) {
					var temp:Sprite = cloneTile(sp);
					temp.x = dest * 120;
					temp.y = sp.y;
					addChild(temp);
					
				}
			}
		}
		
		private function shift(loc:Point,dir:Point) : void {
			for (var i:int = 0;i<numChildren;i++) {
				var sp:Sprite = getChildAt(i) as Sprite;
				if (dir.x && sp.y == int(loc.y / 120) * 120) 
					sp.x = (sp.x + (dir.x * 120 + 840 )) % 840;
				if (dir.y && sp.x == int(loc.x / 120) * 120) 
					sp.y = (sp.y + (dir.y * 120 + 600 )) % 600;
			}
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			
			var sp:Sprite;
			
			var p:Point = new Point(e.stageX,e.stageY);
			p = this.globalToLocal(p);
			
			copyRow = client.getCurrentTool() == ToolsMenu.TOOLBAR_DUPLICATE_ROW ? copyRow : -1;
			copyColumn = client.getCurrentTool() == ToolsMenu.TOOLBAR_DUPLICATE_COLUMN ? copyColumn : -1;
			
			trace("TilesGrid.onMouseDown")
			switch (client.getCurrentTool()) {
				case ToolsMenu.TOOLBAR_CURSOR: 
					sp = getTileAt(p)
					if (sp) 
						removeChild(sp);
			
					var tile:Sprite = client.cloneCurrentTile();
					tile.x = int(p.x / 120) * 120;
					tile.y = int(p.y / 120) * 120;
					addChild(tile)
					break;
				case ToolsMenu.TOOLBAR_ERASER:
					sp = getTileAt(p)
					if (sp) 
						removeChild(sp);
					break;
					
				case ToolsMenu.TOOLBAR_DUPLICATE_ROW:
					if (copyRow == -1)
						copyRow = int(p.y / 120);
					else
						duplicateRow(copyRow,int(p.y / 120))
					break;
					
				case ToolsMenu.TOOLBAR_DUPLICATE_COLUMN:
					if (copyColumn == -1)
						copyColumn = int(p.x / 120);
					else
						duplicateColumn(copyColumn,int(p.x / 120))
					break;
					
				case ToolsMenu.TOOLBAR_SHIFT_RIGHT:
					shift(p,new Point(1,0));
					break;
						
			}
		}
	}
}
