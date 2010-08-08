package {
	import flash.utils.Dictionary;

	/**
	 * @author roikr
	 */
	public class SoundManager {
		//[Embed(source="../sounds/CHAIMS_01.mp3")] private static var CHAIMS_01:Class;
		
		
		//public static const DROP_RAINBOW : String = "CHAIMS_01";
		
		
		private static var sounds:Dictionary = new Dictionary();
		private static var _library:String = "WorldSounds";
		
		private static var _mainChatpet:String = "PIFF";
		
  		public static function setLibrary(library:String) : void {
  			_library = library;
  		}
  		
  		public static function playSound(name:String,client:Object=null,stream:Boolean=false,loop:Boolean = false,volume:Number = 1.0) : RKSound {
  			var sound:RKSound = new RKSound(stream ? _library+"/"+name +".mp3": _library+"_"+name,client,stream,loop,volume);
  			if (loop) 
  				sounds[name] = sound;
  	
  			return sound;
  		}
  		
  		public static function playMusic(name:String) : RKSound {
  			var sound:RKSound = new RKSound("music/"+name+".mp3" ,null,true,true);
  		 	sounds[name] = sound;
    		return sound; 
  		}
  		
  		public static function stopSound(name:String) : void {
  			
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
  		 
  		 public static function playBeep(code:int,client:Object,probability:Number=1.0) : Beep {
  		 	
  		 	if(probability<1 && Math.random() > probability || Beep.getIsChatpetTalking()) // || getIsChatpetTaking())
  		 		return null;
  		 		
  		 		
  		 		
  		 	return new Beep(code,client)
  		}
  		
  		
  		

		public static function chooseAndPlayBeep(arr:Array,client:Object,probability:Number=1.0) : Beep {
  			var index:int = Math.floor(Math.random()*arr.length);
  			return playBeep(arr[index],client,probability);
  		 }
  		 
  		 public static function onClient() : void {
  		 	
  		 }
  		
  		
  		
  		public static function get mainChatpet() : String {
  			return _mainChatpet;
  		}
  		
  		public static function set mainChatpet(name:String) : void {
  			
  			_mainChatpet = name.toUpperCase();
  			
				
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
  		
  		public static function playMainChatpetBeep(client:Object) : Beep {
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
			
			return playBeep(code,client);
  		}
  		
  		public static function onBeepCompleted(obj:Object) : void {
  			trace ("SoundManager::onBeepCompleted - shouldn't get here")
  		}
  		
  		public static function setTestChatpetz(test:Boolean) : void {
  			Beep.setTestChatpetz(test);
  		}
	}
}
