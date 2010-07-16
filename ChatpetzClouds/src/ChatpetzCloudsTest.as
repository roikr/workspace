package {

	/**
	 * @author roikr
	 */
	public class ChatpetzCloudsTest extends TestingGameManager {
		public function ChatpetzCloudsTest() {
			super();
			SoundManager.setTestChatpetz(true)
			SoundManager.setMainChatpet("POPO")
			new BeepsImporter();
			load("ChatpetzClouds.swf");
			
		}
	}
}
