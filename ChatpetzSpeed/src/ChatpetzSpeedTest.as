package {

	/**
	 * @author roikr
	 */
	public class ChatpetzSpeedTest extends TestingGameManager {
		public function ChatpetzSpeedTest() {
			super();
			SoundManager.setTestChatpetz(true)
			SoundManager.mainChatpet="PIFF";
			SoundManager.playMainChatpetBeep(this);
			new BeepsImporter();
			load("Speed.swf");
			
		}
	}
}
