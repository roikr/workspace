package {

	/**
	 * @author roikr
	 */
	public class ChatpetzSafariTest extends TestingGameManager {
		public function ChatpetzSafariTest() {
			super();
			SoundManager.setTestChatpetz(false)
			SoundManager.setMainChatpet("PIFF")
			new BeepsImporter();
			
			load("Safari.swf");
			
		}
	}
}
