package {

	/**
	 * @author roikr
	 */
	public class ChatpetzSafariTest extends TestingGameManager {
		public function ChatpetzSafariTest() {
			super();
			SoundManager.setTestChatpetz(false)
			SoundManager.mainChatpet="PIFF";
			SoundManager.playMainChatpetBeep(this);
			new BeepsImporter();
			
			load("Safari.swf");
			
		}
	}
}
