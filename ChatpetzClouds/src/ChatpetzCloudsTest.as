package {

	/**
	 * @author roikr
	 */
	public class ChatpetzCloudsTest extends TestingGameManager {
		public function ChatpetzCloudsTest() {
			super();
			SoundManager.setTestChatpetz(false)
			SoundManager.mainChatpet="PARPARA";
			SoundManager.playMainChatpetBeep(this);
			new HighBand();
			load("ChatpetzClouds.swf");	
		}
	}
}
