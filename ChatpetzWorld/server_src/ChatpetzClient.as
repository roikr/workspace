package {
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import it.gotoandplay.smartfoxserver.SmartFoxClient;

	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	/**
	 * @author roikr
	 */
	public class ChatpetzClient {
		private var _smartFox:SmartFoxClient;
		private var _client:Object;
		private var _username:String;
		private var _password:String;
		
		public function ChatpetzClient(client:Object,defaultZone:String) {
			super();
			_client = client;
			_smartFox = new SmartFoxClient();
			smartFox.addEventListener(SFSEvent.onConnection, onConnection);
			smartFox.addEventListener(SFSEvent.onConnectionLost, onConnectionLost);
			smartFox.addEventListener(SFSEvent.onLogin, onLogin);
			smartFox.addEventListener(SFSEvent.onRoomListUpdate, onRoomListUpdate);
			smartFox.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponse);
			
			smartFox.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError)
			smartFox.addEventListener(IOErrorEvent.IO_ERROR, onIOError)
			
			smartFox.defaultZone=defaultZone;
			//smartFox.defaultZone="chatpetz";
			//smartFox.defaultZone="h2dbzone";
			//sfs.debug = true
			// Register for generic errors
			
				
		}
		
		public function get smartFox():SmartFoxClient {
			return _smartFox;
		}
		
		public function connect(username:String,password:String) : void {
			_username = username;
			_password = password;
			smartFox.connect("chatpetz.com");
			//smartFox.connect("127.0.0.1",9339);
		}
		
		public function sendMessage(msg:String) : void {
			smartFox.sendPublicMessage(msg);
		}
		
		private function onConnection(evt:SFSEvent):void
		{
			if (evt.params.success)
			{
				_client.logTrace("Connection successful, now performaing login");
				smartFox.login(smartFox.defaultZone, _username, _password);
			}
			else
			{		
				_client.logTrace("Can't connect to " + smartFox.ipAddress + ":" + smartFox.port);
			}
		}
		
		/**
		 * Connection lost event handler.
		 */
		private function onConnectionLost(evt:SFSEvent):void
		{
			_client.onServerConnectionLost();
		}
		
		/**
		 * Login event handler.
		 * On successfull login, nothing happens because we have to wait for the roomlist to be available.
		 */
		private function onLogin(evt:SFSEvent):void
		{
			if (evt.params.success)
			{
				_client.onServerLogin();
				_client.logTrace("Successfully logged in as " + _username);
			}
			else
			{		
				_client.logTrace("Login error: " + evt.params.error);	
				smartFox.disconnect();
			}
		}
		
		/**
		 * On room list received, OpenSpace is initialized.
		 */
		private function onRoomListUpdate(evt:SFSEvent):void
		{
			_client.logTrace("Roomlist received, now a map can be loaded");	
			_client.onServerRoomListUpdate();
			
			// This event also causes the RoomList to be populated
		}
		
		/**
		 * Handle a Security Error
		 */
		public function onSecurityError(evt:SecurityErrorEvent):void
		{
			_client.logTrace("Security error: " + evt.text);
		}
		
		/**
		 * Handle an I/O Error
		 */
		public function onIOError(evt:IOErrorEvent):void
		{
			_client.logTrace("I/O Error: " + evt.text);
		}
		
				
		
		public function onExtensionResponse(evt:SFSEvent) : void 
		{
			var type:String = evt.params.type
   			var data:Object = evt.params.dataObj

    		var command:String = data._cmd
    		
    		if (command == "getList") {
    			_client.dataReceived(data)
				//trace(data.list)
				//var mc : DataGridMC = new DataGridMC();
				//mc.dataGrid.columns = ["ID","USER","PASSWORD","CODE","MOONEYS"];
				//mc.dataGrid.dataProvider = data.list;
	    		
	    		//addChild(mc);
    		}
    		
    		if (command == "logOK")
	        {
	                // Login Successful
				_client.logTrace("Login Successful");
				smartFox.myUserId = data.id;
				smartFox.myUserName = data.name;
				trace("myUserId: " + smartFox.myUserId + ", myUserName: " + smartFox.myUserName)
				
	            smartFox.getRoomList();
	                
	        }
	        else if (command == "logKO")
	        {
	               // Login Failed
	                _client.logTrace(data.err);
	        }
		}
		
	}
}
