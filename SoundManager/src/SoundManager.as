package {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
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
  		 
  		 public static function playBeep(code:int,probability:Number=1.0) : void {
  		 	
  		 	if(probability<1 && Math.random() < probability)
  		 		return;
  		 		
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
    		
    		
  		}
  		
  		public static function chooseAndPlayBeep(arr:Array,probability:Number=1.0) : void {
  			var index:int = Math.floor(Math.random()*arr.length);
  			playBeep(arr[index],probability);
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
				
			var str:String = ""+code.toString();
   			while( str.length < 3 )
      		 str="0" + str;
  		 	
  		 	//var Cls:Class = getDefinitionByName("ChatpetzBeeps_sn2_8_"+str) as Class;
  		 	var Cls:Class = getDefinitionByName("sn2_8_"+str) as Class;
    		var sound:Sound = new Cls() as Sound;
    		sound.play();
  		}
  		
  		public static function setTestChatpetz(test:Boolean) : void {
  			testChatpetz = test;
  		}
 
  		
  		
  		 
	}
}
