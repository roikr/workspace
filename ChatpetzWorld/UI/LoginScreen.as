package {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class LoginScreen extends LoginScreenAssets {
		private var client:Object;
		
		
		public function LoginScreen(client:Object) {
			this.itName.text = "";
			this.itPassword.text = "";
			this.client = client;
			this.btLogin.addEventListener(MouseEvent.MOUSE_DOWN,onLoginButton);
			
		}
		
		
		private function onLoginButton(e:Event) : void {
			if (itPassword.text == "8213496")
				
				client.exit(this); //.itName.text, this.itPassword.text);
			
		}
		
		public function getUser() : String {
			return this.itName.text;
		}
	}
}
