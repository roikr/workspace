package  {

	/**
	 * @author roikr
	 */
	public class SpeedSounds {
		[Embed(source="../sounds/CARDS_IN.mp3")] private static var CARDS_IN:Class;
		[Embed(source="../sounds/CARDS_WRONG.mp3")] private static var CARDS_WRONG:Class;
		[Embed(source="../sounds/FULL_CLOUD.mp3")] private static var FULL_CLOUD:Class;
		
		
		public static const CARDS_IN_SOUND : String = "CARDS_IN";
		public static const CARDS_WRONG_SOUND : String = "CARDS_WRONG";
		public static const FULL_CLOUD_SOUND : String = "FULL_CLOUD";
		
		public static const SPEED_MUSIC : String = "SPEED_GAME_02"
	}
}
