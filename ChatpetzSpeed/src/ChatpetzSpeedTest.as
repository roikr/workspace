package {

	/**
	 * @author roikr
	 */
	public class ChatpetzSpeedTest extends TestingGameManager {
		public function ChatpetzSpeedTest() {
			super();
			//SoundManager.setTestChatpetz(true)
			SoundManager.setMainChatpet("PIFF")
			new BeepsImporter();
			load("Speed.swf");
			
		}
	}
}
