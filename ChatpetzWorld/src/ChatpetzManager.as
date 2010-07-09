package {
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class ChatpetzManager {
		
		private var changeAvatar:ChangeAvatar;
		private var world:ChatpetzWorld;
		
		public function ChatpetzManager(changeAvatar:ChangeAvatar,world:ChatpetzWorld) : void {
			this.changeAvatar = changeAvatar;
			this.world = world;
			
			this.changeAvatar.Piff.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			this.changeAvatar.Popo.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			this.changeAvatar.Poggy.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
		}
		
		public function onAvatarDown(e:Event) : void {
			var button:SimpleButton = e.currentTarget as SimpleButton;
			world.onAvatarDown(button.name);
		}
	}
}
