package {

	/**
	 * @author roikr
	 */
	public class ChatpetzSpeedTest extends TestingGameManager {
		public function ChatpetzSpeedTest() {
			super();
			
			SoundManager.setTestChatpetz(false)
			SoundManager.mainChatpet="PARPARA";
			SoundManager.playMainChatpetBeep(this);
			new HighBand();
			
			load("Speed.swf");
			
		}
	}
}
