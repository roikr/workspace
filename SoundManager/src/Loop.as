package {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	 * @author roikr
	 */
	public class Loop {
		private var sound:Sound;
		private var channel:SoundChannel;
		
		public function Loop(Cls:Class) {
			sound = new Cls() as Sound;
  			channel = sound.play();
  			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
  		}
  		
  		private function onSoundComplete(e:Event) : void {
  			channel = sound.play(); 
  			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}
		
		public function stop() : void {
			channel.stop();
		}
		
	}
}
