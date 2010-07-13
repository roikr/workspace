package {

	/**
	 * @author roikr
	 */
	public class ChatpetzSpeedTest extends TestingGameManager {
		public function ChatpetzSpeedTest() {
			super();
			ChatpetzBeeps.setMainChatpet("PAMMY")
			ChatpetzBeeps.setTestChatpetz(true);
			
			load("Speed.swf");
			
		}
	}
}
