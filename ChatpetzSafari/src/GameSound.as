package {
	
	import sounds.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.getDefinitionByName;
	/**
	 * @author roikr
	 */
	public class GameSound {
		
		private static var importer:Array = [CameraSound,FocusSound];
		
		private var sound:Sound;
		private var channel:SoundChannel;
		private var bPlaying:Boolean;
		
		public function GameSound(className:String) {
			
			var ClassReference:Class = getDefinitionByName(className) as Class;
			
			sound = new ClassReference() as Sound;
			bPlaying = false;
		}
		
		
		public function play() : void  {
			channel = sound.play();
			bPlaying = true;
		}
		
		public function stop() : void {
			channel.stop();
			bPlaying = false;
		}
		
		public function isPlaying() : Boolean {
			return bPlaying;	
		}
		
		
	}
}
