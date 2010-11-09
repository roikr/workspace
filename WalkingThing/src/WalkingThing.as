package {
	import com.chatpetz.WalkingThingContext;
	import com.chatpetz.view.ChangeAvatarView;
	import com.chatpetz.view.RoomView;

	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class WalkingThing extends Sprite {
		
		protected var context:WalkingThingContext;
		
		private var roomView:RoomView;
		private var roomContainer:Sprite;
		
		
		public function WalkingThing() {
			this.context = new WalkingThingContext(this)
		}
		
		public function createUI() : void {
			addChild(roomContainer = new Sprite())
			addChild(new ChangeAvatarView());
		}
		
		public function setRoomView(roomView:RoomView) : void {
			this.roomView = roomView;
			roomContainer.addChild(this.roomView);
		}
	}
}
