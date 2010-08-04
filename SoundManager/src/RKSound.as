package {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;

	/**
	 * @author roikr
	 */
	public class RKSound {
		private var sound:Sound;
		private var channel:SoundChannel;
		private var client:Object;
		
		private var loop:Boolean;
		private var _playing:Boolean;
		
		
		public function RKSound(name:String,client:Object,stream:Boolean,loop:Boolean) {
			
			this.client = client;
			
			this.loop = loop;
			
			if (stream) {
				try {
	            	sound = new Sound();
	            	var req:URLRequest = new URLRequest(name);
	  				trace(req.url);
	            	sound.load(req);
	            }
	            catch (err:Error) {
	                trace(err.message);
	            }
			}
			else
			{
				var Cls:Class = getDefinitionByName(name) as Class;
				sound = new Cls() as Sound;
			}
  				
			sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
  			channel = sound.play();
  			_playing = true;
  			
  			
  			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
  			
  			
  		}
  		
  		private function errorHandler(errorEvent:IOErrorEvent):void {
            trace( "The sound could not be loaded: " + errorEvent.text);
        }
  		
  		private function onSoundComplete(e:Event) : void {
  			
  			
  			if (client) {
  				trace("RKSound::onSoundComplete "+client)
  				client.onSoundComplete(this);
  			}
  			
  			if (loop) {
  				channel = sound.play(); 
  				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
  			} else {
  				_playing = false;
  			}
  			
  		
		}
		
		public function stop() : void {
			_playing = false;
			channel.stop();
		}
		
		public function get playing() : Boolean {
			return _playing;
			
		}
	}
}
