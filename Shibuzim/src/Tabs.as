package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class Tabs extends TabsMC {
		
		private var client:Object;
		private var _tab:int;
		
		public function Tabs(client:Object) {
			this.client = client;
			y = 548;
			x = 549;
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			tab = 0;
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			var p:Point = new Point(e.stageX,e.stageY);
			p = this.globalToLocal(p);
			
			
			tab  = p.x/99;
			
			client.onClient(this);
			
			
		}
		
		public function set tab(tabNum:int) : void {
			
			tabNum = Math.min(tabNum,2);
			
			for (var i:int = 0;i<numChildren;i++ ) {
				(this.getChildAt(i) as MovieClip).gotoAndStop(1);
			}
			(this.getChildAt(2-tabNum) as MovieClip).gotoAndStop(2);
			_tab = tabNum;
		}
		
		public function get tab() : int {
			return _tab;
		}
	}
}
