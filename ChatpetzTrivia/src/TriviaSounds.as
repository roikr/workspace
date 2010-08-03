package {

	/**
	 * @author roikr
	 */
	public class TriviaSounds {
		
		
		[Embed(source="../sounds/CORRECT_ANSWER.mp3")] private static var CORRECT_ANSWER:Class;
		[Embed(source="../sounds/FULL_CLOUD.mp3")] private static var FULL_CLOUD:Class;
		[Embed(source="../sounds/FULL_CLOUD2.mp3")] private static var FULL_CLOUD2:Class;
		[Embed(source="../sounds/OPENING_STONES.mp3")] private static var OPENING_STONES:Class;
		[Embed(source="../sounds/RIGHT.mp3")] private static var RIGHT:Class;
		[Embed(source="../sounds/STONES_IN.mp3")] private static var STONES_IN:Class;
		[Embed(source="../sounds/STONES_OUT.mp3")] private static var STONES_OUT:Class;
		[Embed(source="../sounds/WRONG.mp3")] private static var WRONG:Class;
		[Embed(source="../sounds/WRONG_ANSWER.mp3")] private static var WRONG_ANSWER:Class;

		
		public static const CORRECT_ANSWER_SOUND : String = "CORRECT_ANSWER";
		public static const OPENING_STONES_SOUND : String = "OPENING_STONES";
		public static const RIGHT_SOUND : String = "RIGHT";
		public static const STONES_IN_SOUND : String = "STONES_IN";
		public static const STONES_OUT_SOUND : String = "STONES_OUT";
		public static const WRONG_SOUND : String = "WRONG";
		public static const WRONG_ANSWER_SOUND : String = "WRONG_ANSWER";
		
		
	}
}