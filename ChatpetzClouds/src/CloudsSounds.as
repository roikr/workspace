package {

	/**
	 * @author roikr
	 */
	public class CloudsSounds {
		[Embed(source="../sounds/FULL_CLOUD.mp3")] private static var FULL_CLOUD:Class;
		[Embed(source="../sounds/CHAIMS_01.mp3")] private static var CHAIMS_01:Class;
		[Embed(source="../sounds/POP_01.mp3")] private static var POP_01:Class;
		[Embed(source="../sounds/POP_02.mp3")] private static var POP_02:Class;
		[Embed(source="../sounds/PUT_CREAM_01.mp3")] private static var PUT_CREAM_01:Class;
		[Embed(source="../sounds/PUT_CREAM_02.mp3")] private static var PUT_CREAM_02:Class;
		[Embed(source="../sounds/RAIN_01.mp3")] private static var RAIN_01:Class;
		[Embed(source="../sounds/SPACESHIP_IN_01.mp3")] private static var SPACESHIP_IN_01:Class;
		[Embed(source="../sounds/SPACESHIP_OUT_01.mp3")] private static var SPACESHIP_OUT_01:Class;
		[Embed(source="../sounds/STEAM_01.mp3")] private static var STEAM_01:Class;
		[Embed(source="../sounds/SWISH_01.mp3")] private static var SWISH_01:Class;
		[Embed(source="../sounds/SWISH_02.mp3")] private static var SWISH_02:Class;
		[Embed(source="../sounds/TAKE_CREAM_01.mp3")] private static var TAKE_CREAM_01:Class;
		[Embed(source="../sounds/WRONG.mp3")] private static var WRONG:Class;
		
		public static const FULL_CLOUD_SOUND : String = "FULL_CLOUD";
		public static const DROP_RAINBOW : String = "CHAIMS_01";
		public static const COMIC_BULB : String = "POP_01";
		public static const TAKE_UMBRELLA : String = "POP_02";
		public static const DROP_ICECREAM : String = "PUT_CREAM_01";
		public static const DROP_UMBRELLA : String = "PUT_CREAM_02";
		public static const DROP_RAIN : String = "RAIN_01";
		public static const SPACESHIP_LAND : String = "SPACESHIP_IN_01";
		public static const SPACESHIP_TAKEOFF : String = "SPACESHIP_OUT_01";
		public static const CLOUD_OUT : String = "STEAM_01";
		public static const TAKE_CLOUD : String = "SWISH_01";
		public static const TAKE_RAIN_BOW : String = "SWISH_02";
		public static const TAKE_ICECREAM : String = "TAKE_CREAM_01";
		public static const COMIC_WRONG : String = "WRONG";
		public static const CLOUDS_MUSIC : String = "CLOUD_CREAM_GAME_01"
		
		//private static var sounds:Dictionary = new Dictionary();
		
		
		/*
  		public static function getClass(name:String) : Class {
  			return  getDefinitionByName("SoundsLibrary_"+name) as Class;
    		
  		}
  		 * 
  		 */
  		 /*
  		 public static function play(name:String) : void {
  		 	var Cls:Class = getDefinitionByName("SoundsLibrary_"+name) as Class;
    		var sound:Sound = new Cls() as Sound;
  			sound.play();
    		
  		}
  		
  		public static function playMusic(name:String) : void {
  			
  		 	var Cls:Class = getDefinitionByName("SoundsLibrary_"+name) as Class;
  		 	sounds[name] = new ChatpetzSound(Cls);
    		
  		}
  		
  		public static function stopMusic(name:String) : void {
  			
  			var sound:ChatpetzSound = sounds[name];
  		 	if (sound) {
  		 		sound.stop();
  		 		delete sounds[name];
  		 	}
  		 	
    		
  		}
  		 * 
  		 */
  		
	}
}
