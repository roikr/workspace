package {
	import fl.video.VideoEvent;
	import fl.video.VideoState;
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
			client.onClient(this);
		}
		
		private function onSkip(e : Event) : void {
			switch (this.flvPlayer.state) {
			
				case VideoState.BUFFERING:
				case VideoState.LOADING:
				case VideoState.PLAYING:
				case VideoState.SEEKING: {
					this.flvPlayer.autoPlay = false;
					this.flvPlayer.pause();
					this.flvPlayer.stop();
				} break;
			}
				
			client.onClient(this);
		}
		
		
		
		public function getVideoName() : String {
			return this.flvPlayer.source;
		}
		
		
	}
}
