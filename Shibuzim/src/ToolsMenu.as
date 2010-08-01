package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class ToolsMenu extends ToolbarMC {
		
		
		public static const TOOLBAR_CURSOR:int = 0;
		public static const TOOLBAR_MAGNIFIER:int = 1;
		public static const TOOLBAR_INK: int = 2;
		public static const TOOLBAR_TILE_ERASER:int = 3;
		public static const TOOLBAR_GRID_FILLER:int = 4;
		public static const TOOLBAR_GRID_ERASER:int = 5;
		public static const TOOLBAR_ROW_FILLER:int = 6;
		public static const TOOLBAR_COLUMN_FILLER:int = 7;
		public static const TOOLBAR_NONE:int = 8;
		public static const TOOLBAR_COST:int = 9;
		public static const TOOLBAR_INVITATION:int = 10;
		
		
		//private var client:Object;
		private var _tool:int;
		
		private var client:Object;
		
		public function ToolsMenu(client:Object) { // client:Object
			this.client = client;
			y=235;
			x=856;
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			tool = 0;
			
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			var p:Point = new Point(e.stageX,e.stageY);
			p = this.globalToLocal(p);
			
			this.tool = (p.y-3) / 28;
			
			client.onClient(this);
			
			//client.usingTool(tool);
		}
		
		public function set tool(tool:int) : void {
			_tool = tool;
			for (var i:int = 0;i<numChildren;i++ )
				(this.getChildAt(i) as MovieClip).gotoAndStop(1);
			(this.getChildAt(10-tool) as MovieClip).gotoAndStop(2);
		}
		
		public function get tool() : int {
			return _tool;
		}
		
	}
}
