package {

	/**
	 * @author roikr
	 */
	public class ChatpetzTriviaTest extends TestingGameManager {
		public function ChatpetzTriviaTest() {
			super();
			SoundManager.setTestChatpetz(false)
			SoundManager.mainChatpet="PARPARA";
			SoundManager.playMainChatpetBeep(this);
			new HighBand();
			
			load("ChatpetzTrivia.swf");
			
		}
	}
}
