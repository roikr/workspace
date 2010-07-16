package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	/**
	 * @author roikr
	 */
	public class MoviePlayer extends Sprite {
		private var client:Object;
		private var movie:String;
		private var mc:MovieClip;
		
		private static var importer:Array = [ EarthToMoonMC,MoonToEarthMC];
		
		public function MoviePlayer(movie:String,client:Object) {
			this.client = client;
			this.movie = movie;
			var ref:Class = getDefinitionByName(movie) as Class;
			addChild(mc = new ref() as MovieClip);
			mc.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
		}
		
		private function onEnterFrame(e:Event) : void {
			if (mc.currentFrameLabel && mc.currentFrameLabel=="end"){
				mc.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				client.exit(this);
			}
		}
		
		public function getMovieName() : String {
			return movie;
		}
		
		
	}
}
