package {

	/**
	 * @author roikr
	 */
	public class ChatpetzTriviaTest extends TestingGameManager {
		public function ChatpetzTriviaTest() {
			super();
			SoundManager.setTestChatpetz(true)
			SoundManager.setMainChatpet("PARPARA")
			new BeepsImporter();
			load("ChatpetzTrivia.swf");
			
		}
	}
}
