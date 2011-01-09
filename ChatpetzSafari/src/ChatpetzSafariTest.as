package {

	/**
	 * @author roikr
	 */
	public class ChatpetzSafariTest extends TestingGameManager {
		public function ChatpetzSafariTest() {
			super();
			SoundManager.setTestChatpetz(false)
			SoundManager.mainChatpet="PARPARA";
			SoundManager.playMainChatpetBeep(this);
			new HighBand();
			
			load("Safari.swf");
			
		}
	}
}
