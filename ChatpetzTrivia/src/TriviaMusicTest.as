package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TriviaMusicTest extends Sprite {
		
		public static const TRIVIA_MUSIC_A : String = "MOONIONER_01"
		
		public function TriviaMusicTest() {
			SoundManager.setLibrary("TriviaSounds");
			SoundManager.playMusic(TRIVIA_MUSIC_A);
		}
	}
}
