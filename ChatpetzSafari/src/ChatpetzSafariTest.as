package {

	/**
	 * @author roikr
	 */
	public class ChatpetzSafariTest extends TestingGameManager {
		public function ChatpetzSafariTest() {
			super();
			SoundManager.setTestChatpetz(true)
			SoundManager.setMainChatpet("PARPARA")
			new BeepsImporter();
			
			load("Safari.swf");
			
		}
	}
}
