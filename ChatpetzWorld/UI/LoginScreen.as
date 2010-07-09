package {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class LoginScreen extends LoginScreenAssets {
		private var client:Object;
		
		
		public function LoginScreen(client:Object,container:DisplayObjectContainer) {
			
			this.client = client;
			container.addChild(this);
			visible = false;
			
			this.btLogin.addEventListener(MouseEvent.MOUSE_DOWN,onLoginButton);
			
		}
		
		public function open() : void {
			this.itName.text = "";
			this.itPassword.text = "";
			visible = true;
		}
		
		public function close() : void {
			visible = false;
		}
		
		private function onLoginButton(e:Event) : void {
			if (itPassword.text == "8213496")
				client.login(this.itName.text, this.itPassword.text);
			
		}
	}
}
