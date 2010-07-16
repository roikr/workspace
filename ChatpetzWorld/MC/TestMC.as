package {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TestMC extends Sprite {
		
	
		public function TestMC() {
			
			//addChild(new Shop(this));
			addChild(new EarthMap(this));
			//addChild(new MoviePlayer("MoonToEarthMC",this))
			
		}
		
		public function exit(obj:Object) : void {
			trace(obj);
			if (obj is MoviePlayer) {
				trace((obj as MoviePlayer).getMovieName())
			} else if (obj is EarthMap) {
				trace((obj as EarthMap).getDestination())
			}
			removeChild(obj as DisplayObject);
		}
		
	}
}
