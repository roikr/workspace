package {

	/**
	 * @author roikr
	 */
	public class ChatpetzTriviaTest extends TestingGameManager {
		public function ChatpetzTriviaTest() {
			super();
			ChatpetzBeeps.setTestChatpetz(true)
			ChatpetzBeeps.setMainChatpet("PARPARA")
			load("ChatpetzTrivia.swf");
			
		}
	}
}
