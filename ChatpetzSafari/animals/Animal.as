package {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class Animal extends MovieClip {
		
		private var bPlaying:Boolean;
		
		public function Animal() {
			bPlaying = false;
		}
		
		public function distance(obj:DisplayObject) : int {
			for (var i:int = 0;i<numChildren;i++) {
				if (getChildAt(i) is CenterMarker) {
					var mc:CenterMarker = getChildAt(i)  as CenterMarker;
					var p1:Point = mc.localToGlobal(new Point(0,0));
					var p2:Point = obj.localToGlobal(new Point(0,0));
					//trace(p1,p2);
					return Point.distance(p1,p2);
				}
			}	
			
			trace("couldn't find center");
			return 5000;		
		}
		
		public function startAnimation() : void {
			if (!bPlaying) {
				gotoAndPlay("start");
				bPlaying = true;
			}
		}
		
		
		
	}
}
