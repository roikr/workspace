package {

	/**
	 * @author roikr
	 */
	public class ChatpetzTriviaTest extends TestingGameManager {
		public function ChatpetzTriviaTest() {
			super();
			SoundManager.setTestChatpetz(false)
			SoundManager.mainChatpet="PIFF";
			SoundManager.playMainChatpetBeep(this);
			new BeepsImporter();
			load("ChatpetzTrivia.swf");
			
		}
	}
}
