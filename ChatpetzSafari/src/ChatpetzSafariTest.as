package {

	/**
	 * @author roikr
	 */
	public class ChatpetzSafariTest extends TestingGameManager {
		public function ChatpetzSafariTest() {
			super();
			ChatpetzBeeps.setMainChatpet("PARPARA")
			ChatpetzBeeps.setTestChatpetz(true);
			
			load("Safari.swf");
			
		}
	}
}
