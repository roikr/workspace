package {
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class ChatpetzManager {
		
		private var changeAvatar:ChangeAvatar;
		private var worldUI:WorldUI;
		
		public function ChatpetzManager(changeAvatar:ChangeAvatar,worldUI:WorldUI) : void {
			
			this.changeAvatar = changeAvatar;
			this.worldUI = worldUI;
			
			this.changeAvatar.Piff.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			this.changeAvatar.Popo.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			this.changeAvatar.Poggy.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			this.changeAvatar.Pammy.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			this.changeAvatar.Pizz.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			this.changeAvatar.Parpara.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			
			
		}
		
		public function onAvatarDown(e:Event) : void {
			var button:SimpleButton = e.currentTarget as SimpleButton;
			worldUI.onAvatarDown(button.name);
		}
		
		
	}
}
