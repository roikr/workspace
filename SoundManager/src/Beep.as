package {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class Beep {
		
		private var sound:RKSound;
		private var _code:int;
		private var client:Object;
		private var timer:Timer;
		
		private static var bChatpetIsTalking : Boolean = false;
		private static var bTestChatpetz:Boolean = false;
		
		
		public function Beep(code:int,client:Object) {
			
			_code = code;
			this.client = client;
			
			var str:String = ""+code.toString();
   			while( str.length < 3 )
      			str="0" + str;
  		 	
  		 
  		 	sound =  new RKSound("HIGH_BAND.WAV_"+str+".wav",this,false,false);
			Beep.bChatpetIsTalking = true;
  		 	
  		 	/*
  		 	//var Cls:Class = getDefinitionByName("ChatpetzBeeps_sn2_8_"+str) as Class;
  		 	try {
                var Cls:Class = getDefinitionByName("sn2_8_"+str) as Class;
    			var sound:Sound = new Cls() as Sound;
    			var channel:SoundChannel = sound.play();
    			if (testChatpetz) {
  					channel.addEventListener(Event.SOUND_COMPLETE,onBeepComplete);
  					_code = code;
    			}
            }
            catch(e:ReferenceError) {
                trace(e);
            }
             * */
             
            
            //timer = new Timer()
    		
    		//currentDuration = 1090;
    		
    		
    		
			//bChatpetIsTalking = true;
			//trace("beep and talking has started for " + currentDuration);
			//return currentDuration
		}
		
		public function onSoundComplete(obj:Object) : void {
			if (_code<192) {
    			var currentDuration:int =SoundsDurations.duration(SoundManager.mainChatpet, _code);
    			timer = new Timer(currentDuration,1);
    			timer.addEventListener(TimerEvent.TIMER,onTimer);
    			timer.start();
    			
    			if (Beep.bTestChatpetz) {
					new RKSound("mp3/" + SoundManager.mainChatpet + "/" + SoundManager.mainChatpet+_code.toString()+".mp3",null,true,false);
  				}
    			
    		} else {
    			Beep.bChatpetIsTalking = false;
    			client.onBeepCompleted(this);
    		}
    		
    		
		}
		
		private function onTimer(e:Event) : void {
  			trace("beep and talking has finished");
			//bChatpetIsTalking = false;
			//timer = null;
			//trace(timer); 
			Beep.bChatpetIsTalking = false;
			client.onBeepCompleted(this);
		}
		
		public static function setTestChatpetz(test:Boolean) : void {
  			Beep.bTestChatpetz = test;
  		}
  		
  		public function get code() : int {
  			return _code;
  		}

		public static function getDuration(code:int) : int {
			return code<192 ? 1090+SoundsDurations.duration(SoundManager.mainChatpet, code) : 1090;
		}
		
		public function get duration() : int {
			return _code<192 ? 1090+SoundsDurations.duration(SoundManager.mainChatpet, _code) : 1090;
		}
		
		public static function getIsChatpetTalking() : Boolean {
			return bChatpetIsTalking;
		}
	}
}
