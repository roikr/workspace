package {

	/**
	 * @author roikr
	 */
	public class ChatpetzTriviaTest extends TestingGameManager {
		public function ChatpetzTriviaTest() {
			super();
			SoundManager.setTestChatpetz(false)
			SoundManager.setMainChatpet("PIFF")
			new BeepsImporter();
			load("ChatpetzTrivia.swf");
			
		}
	}
}
