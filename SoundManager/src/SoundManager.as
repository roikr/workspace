package {
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * @author roikr
	 */
	public class SoundManager {
		//[Embed(source="../sounds/CHAIMS_01.mp3")] private static var CHAIMS_01:Class;
		
		
		//public static const DROP_RAINBOW : String = "CHAIMS_01";
		
		
		private static var sounds:Dictionary = new Dictionary();
		private static var _library:String = "SoundsLibrary";
		
		
		/*
  		public static function getClass(name:String) : Class {
  			return  getDefinitionByName("SoundsLibrary_"+name) as Class;
    		
  		}
  		 * 
  		 */
  		 
  		public static function setLibrary(library:String) : void {
  			_library = library;
  		}
  		
  		public static function playSound(name:String) : void {
  		 	var Cls:Class = getDefinitionByName(_library+"_"+name) as Class;
    		var sound:Sound = new Cls() as Sound;
  			sound.play();
    		
  		}
  		
  		public static function playMusic(name:String) : void {
  			
  		 	var Cls:Class = getDefinitionByName(_library+"_"+name) as Class;
  		 	sounds[name] = new Loop(Cls);
    		
  		}
  		
  		public static function stopMusic(name:String) : void {
  			
  			var sound:Loop = sounds[name];
  		 	if (sound) {
  		 		sound.stop();
  		 		delete sounds[name];
  		 	}
  		}
  		
  		public static function stopAllSounds() : void  {
  			for each (var sound:Loop in sounds) {
  				sound.stop();
  			}
  		}
  		
  		 
  		 
	}
}
