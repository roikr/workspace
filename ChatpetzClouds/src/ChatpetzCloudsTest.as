package {

	/**
	 * @author roikr
	 */
	public class ChatpetzCloudsTest extends TestingGameManager {
		public function ChatpetzCloudsTest() {
			super();
			ChatpetzBeeps.setMainChatpet("POPO")
			ChatpetzBeeps.setTestChatpetz(true);
			load("ChatpetzClouds.swf");
			
		}
	}
}
