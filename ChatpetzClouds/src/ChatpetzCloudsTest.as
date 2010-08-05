package {

	/**
	 * @author roikr
	 */
	public class ChatpetzCloudsTest extends TestingGameManager {
		public function ChatpetzCloudsTest() {
			super();
			SoundManager.setTestChatpetz(false)
			SoundManager.mainChatpet="PIFF";
			SoundManager.playMainChatpetBeep(this);
			new BeepsImporter();
			load("ChatpetzClouds.swf");	
		}
	}
}
