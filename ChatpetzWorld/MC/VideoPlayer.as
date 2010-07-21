package {
	import fl.video.VideoEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class VideoPlayer extends VideoPlayerSprite {
		
		private var client:Object;
		
		
		
		
		
		public function VideoPlayer(video:String,client:Object) {
			this.client = client;
			this.flvPlayer.source = video;
			this.flvPlayer.addEventListener(VideoEvent.COMPLETE, onVideoComplete)
			
			this.bSkip.addEventListener(MouseEvent.MOUSE_DOWN, onSkip)
		}
		
		private function onVideoComplete(e:Event) : void {
			client.exit(this);
		}
		
		private function onSkip(e:Event) : void {
			
			this.flvPlayer.stop();
			client.exit(this);
		}
		
		
		
		public function getVideoName() : String {
			return this.flvPlayer.source;
		}
		
		
	}
}
