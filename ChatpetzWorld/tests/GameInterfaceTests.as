package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class GameInterfaceTests extends Sprite {
		
		private var gameInterface : GameInterface;
		
		public function GameInterfaceTests() {
			addChild(gameInterface=new GameInterface(new DummyGameManager()));
			gameInterface.open();
		}
		
		public function returnToWorld() : void {
			trace("returnToWorld");
		}
	}
}
