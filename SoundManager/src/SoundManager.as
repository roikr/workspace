package {
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;

	/**
	 * @author roikr
	 */
	public class SoundManager {
		//[Embed(source="../sounds/CHAIMS_01.mp3")] private static var CHAIMS_01:Class;
		
		
		//public static const DROP_RAINBOW : String = "CHAIMS_01";
		
		
		private static var sounds:Dictionary = new Dictionary();
		private static var _library:String = "WorldSounds";
		
		private static var mainChatpet:String = "PIFF";
		private static var _code:int;
		private static var testChatpetz:Boolean = false;
		
		private static var bChatpetIsTalking : Boolean = false;
		private static var timer:Timer;
		private static var currentDuration:int;
		/*
  		public static function getClass(name:String) : Class {
  			return  getDefinitionByName("SoundsLibrary_"+name) as Class;
    		
  		}
  		 * 
  		 */
  		 
  		public static function setLibrary(library:String) : void {
  			_library = library;
  		}
  		
  		public static function playSound(name:String,client:Object=null,stream:Boolean=false) : void {
  			var sound: RKSound = new RKSound(stream ? _library+"/"+name +".mp3": _library+"_"+name,client,stream,false);
  		}
  		
  		public static function playMusic(name:String) : void {
  			
  		 	sounds[name] = new RKSound("music/"+name+".mp3" ,null,true,true);
    		
  		}
  		
  		public static function stopMusic(name:String) : void {
  			
  			var sound:RKSound = sounds[name];
  		 	if (sound) {
  		 		sound.stop();
  		 		delete sounds[name];
  		 	}
  		}
  		
  		public static function stopAllSounds() : void  {
  			for each (var sound:RKSound in sounds) {
  				sound.stop();
  			}
  		}
  		
  		
		
		/*
  		private static function getClass(name:String) : Class {
  			return  getDefinitionByName("SoundsLibrary_"+name) as Class;
    		
  		}
  		 * 
  		 */
  		 
  		 public static function playBeep(code:int,probability:Number=1.0) : int {
  		 	
  		 	if(probability<1 && Math.random() < probability || getIsChatpetTaking())
  		 		return 0;
  		 		
  		 	var str:String = ""+code.toString();
   			while( str.length < 3 )
      		 str="0" + str;
  		 	
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
            
            //timer = new Timer()
    		
    		currentDuration = 1090;
    		
    		if (code<192) {
    			currentDuration+=SoundsDurations.duration(mainChatpet, code);
    		}
    		timer = new Timer(currentDuration,1);
    		timer.addEventListener(TimerEvent.TIMER,onTimer);
    		timer.start();
			bChatpetIsTalking = true;
			trace("beep and talking has started for " + currentDuration);
			return currentDuration
  		}
  		
  		private static function onTimer(e:Event) : void {
  			trace("beep and talking has finished");
			bChatpetIsTalking = false;
			timer = null;
			//trace(timer); 
		}
  		
  		public static function getIsChatpetTaking() : Boolean {
			return bChatpetIsTalking;
		}

		public static function chooseAndPlayBeep(arr:Array,probability:Number=1.0) : int {
  			var index:int = Math.floor(Math.random()*arr.length);
  			return playBeep(arr[index],probability);
  		 }
  		
  		
  		
  		private static function onBeepComplete(e:Event) : void {
  			
  			
            
            try {
            	var snd:Sound = new Sound();
            	var req:URLRequest = new URLRequest("mp3/" + mainChatpet + "/" + mainChatpet+_code.toString()+".mp3");
  				trace(req.url);
            	snd.load(req);
           		snd.play();
            }
            catch (err:Error) {
                trace(err.message);
            }
            
  		}
  		
  		public static function setMainChatpet(name:String) : void {
  			
  			mainChatpet = name.toUpperCase();
  			var code:int;
  			switch (mainChatpet) {
				case "PIZZ":
					code = ChatpetzCodes.CONTROL_SELECT_PIZZ;
					break;	
				case "PIFF":
					code = ChatpetzCodes.CONTROL_SELECT_PIFF;
					break;
				case "PARPARA":
					code = ChatpetzCodes.CONTROL_SELECT_PARPARA;
					break;	
				case "PAMMY":
					code = ChatpetzCodes.CONTROL_SELECT_PAMMY;
					break;	
				case "POGGY":
					code = ChatpetzCodes.CONTROL_SELECT_POGGY;
					break;
				case "POPO":
					code = ChatpetzCodes.CONTROL_SELECT_POPO;
					break;	
			}
			
			playBeep(code);
				
				/*
			var str:String = ""+code.toString();
   			while( str.length < 3 )
      		 str="0" + str;
  		 	
  		 	//var Cls:Class = getDefinitionByName("ChatpetzBeeps_sn2_8_"+str) as Class;
  		 	var Cls:Class = getDefinitionByName("sn2_8_"+str) as Class;
    		var sound:Sound = new Cls() as Sound;
    		sound.play();
    		 
    		 */
  		}
  		
  		public static function setTestChatpetz(test:Boolean) : void {
  			testChatpetz = test;
  		}
 
  		
  		
  		 
	}
}
