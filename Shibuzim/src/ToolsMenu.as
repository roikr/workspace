package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class ToolsMenu extends ToolbarMC {
		
		public static const TOOLBAR_VIDEO:int = 0;
		public static const TOOLBAR_CURSOR:int = 1;
		public static const TOOLBAR_ROW_FILLER:int = 2;
		public static const TOOLBAR_COLUMN_FILLER:int = 3;
		public static const TOOLBAR_GRID_FILLER:int = 4;
		public static const TOOLBAR_INK: int = 5;
		public static const TOOLBAR_TILE_ERASER:int = 6;
		public static const TOOLBAR_GRID_ERASER:int = 7;
		public static const TOOLBAR_UNDO:int = 8;
		public static const TOOLBAR_MAGNIFIER:int = 9;
		public static const TOOLBAR_COST:int = 10;
		public static const TOOLBAR_INVITATION:int = 11;
		
		
		//private var client:Object;
		
		private var _selectedTool:int;
		private var _immediateTool:int;
		
		private var client:Object;
		
		public function ToolsMenu(client:Object) { // client:Object
			this.client = client;
			y=206;
			x=856;
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			tool = TOOLBAR_CURSOR;
			new SmartTooltip(this);
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			var p:Point = new Point(e.stageX,e.stageY);
			p = this.globalToLocal(p);
			
			this.tool = (p.y-3) / 28;
			
			
			
			//client.usingTool(tool);
		}
		
		public function set tool(tool:int) : void {
			switch(tool) {
				case ToolsMenu.TOOLBAR_CURSOR:
				case ToolsMenu.TOOLBAR_ROW_FILLER :
				case ToolsMenu.TOOLBAR_COLUMN_FILLER :
				case ToolsMenu.TOOLBAR_TILE_ERASER : 
				case ToolsMenu.TOOLBAR_INK:
				case ToolsMenu.TOOLBAR_MAGNIFIER:
					_selectedTool = tool;
					for (var i:int = 0;i<numChildren;i++ ) {
						(this.getChildAt(i) as MovieClip).gotoAndStop(1);
					}
					(this.getChildAt(11-tool) as MovieClip).gotoAndStop(2);
					break;
					
				case ToolsMenu.TOOLBAR_VIDEO:
				case ToolsMenu.TOOLBAR_GRID_FILLER :
				case ToolsMenu.TOOLBAR_GRID_ERASER :
				case ToolsMenu.TOOLBAR_COST:
				case ToolsMenu.TOOLBAR_UNDO:
				case ToolsMenu.TOOLBAR_INVITATION:
					_immediateTool = tool;
					client.onClient(this);
					break;
			}
			
			
		}
		
		public function get selectedTool() : int {
			return _selectedTool;
		}
		
		public function get immediateTool() : int {
			return _immediateTool;
		}
		
		public function getTooltipText(pnt:Point) : String {
			pnt = globalToLocal(pnt);
			var str:String;
			var tool:int = (pnt.y-3) / 28;
			
			switch ( tool) {
				case ToolsMenu.TOOLBAR_VIDEO:
					str= 'סרט הדרכה'
					break;
				case ToolsMenu.TOOLBAR_CURSOR:
					str= 'בחירה'
					break;
				case ToolsMenu.TOOLBAR_ROW_FILLER :
					str= 'מלוי שורה'
					break;
				case ToolsMenu.TOOLBAR_COLUMN_FILLER :
					str= 'מלוי טור'
					break;
				case ToolsMenu.TOOLBAR_TILE_ERASER : 
					str= 'מחיקת אריח'
					break;
				case ToolsMenu.TOOLBAR_INK:
					str= 'בחירת אריח'
					break;
				case ToolsMenu.TOOLBAR_MAGNIFIER:
					str= 'הגדלה'
					break;
				case ToolsMenu.TOOLBAR_GRID_FILLER :
					str= 'מלוי משטח'
					break;
				case ToolsMenu.TOOLBAR_GRID_ERASER :
					str= 'מחיקת משטח'
					break;
				case ToolsMenu.TOOLBAR_COST:
					str= 'מחיר'
					break;
				case ToolsMenu.TOOLBAR_UNDO:
					str= 'ביטול פעולה אחרונה'
					break;
				case ToolsMenu.TOOLBAR_INVITATION:
					str = 'שמור/שלח הזמנה'
					break;
				
			}
			return str;
		}
		
	}
}
