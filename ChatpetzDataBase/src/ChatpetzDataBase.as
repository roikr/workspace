package {
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import it.gotoandplay.smartfoxserver.SmartFoxClient;

	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	/**
	 * @author roikr
	 */
	public class ChatpetzDataBase {
		
		private var sfs:SmartFoxClient;
		public static const NEWLINE:String = "\n";
		
		private var _client:Object;
	
		
		public function ChatpetzDataBase(client:Object) {
			_client = client;
			sfs = new SmartFoxClient();
			sfs.addEventListener(SFSEvent.onConnection, onConnection);
			sfs.addEventListener(SFSEvent.onConnectionLost, onConnectionLost);
			//sfs.addEventListener(SFSEvent.onLogin, onLogin);
			sfs.addEventListener(SFSEvent.onRoomListUpdate, onRoomListUpdate);
			sfs.addEventListener(SFSEvent.onJoinRoom, onJoinRoom);
			sfs.addEventListener(SFSEvent.onJoinRoomError, onJoinRoomError);
			sfs.addEventListener(SFSEvent.onExtensionResponse, onExtensionResponse);
			sfs.defaultZone="h2dbzone";
			//sfs.debug = true
			// Register for generic errors
			sfs.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError)
			sfs.addEventListener(IOErrorEvent.IO_ERROR, onIOError)
			
			if (!sfs.isConnected)
				sfs.connect("127.0.0.1",9339);
				//sfs.connect("chatpetz.com",9339);
			else
				debugTrace("You are already connected!");
		}
		
		/**
		 * Handle connection
		 */
		public function onConnection(evt:SFSEvent):void
		{
			var success:Boolean = evt.params.success;
			
			if (success)
			{
				debugTrace("Connection successfull!");
				
				// sfs.defaultZone refers to the Zone set in the external XML file
				// We use an empty name and passoword to login as guest user
				sfs.login(sfs.defaultZone, "Roee", "rkttt");
			}
			else
			{
				debugTrace("Connection failed!");	
			}
		}
		
		/**
		 * Handle connection lost
		 */
		public function onConnectionLost(evt:SFSEvent):void
		{
			debugTrace("Connection lost!");
		}
		
		/**
		 * Handle login response
		 */
		 
		/*
		public function onLogin(evt:SFSEvent):void
		{
			if (evt.params.success)
			{
				debugTrace("Successfully logged in");
				
			}
			else
			{
				debugTrace("Login failed. Reason: " + evt.params.error);
			}
		}
		 * 
		 */
		
		/**
		 * Handle room list
		 */
		public function onRoomListUpdate(evt:SFSEvent):void
		{
			debugTrace("Room list received");
			
			// Tell the server to auto-join us in the default room for this Zone
			sfs.autoJoin();
		}
		
		/**
		 * Handle successfull join
		 */
		public function onJoinRoom(evt:SFSEvent):void
		{
			debugTrace("Successfully joined room: " + evt.params.room.getName());
			sfs.sendXtMessage("h2db_ext", "getList", {})
		}
		
		/**
		 * Handle problems with join
		 */
		public function onJoinRoomError(evt:SFSEvent):void
		{
			debugTrace("Problems joining default room. Reason: " + evt.params.error);	
		}
		
		
		/**
		 * Handle a Security Error
		 */
		public function onSecurityError(evt:SecurityErrorEvent):void
		{
			debugTrace("Security error: " + evt.text);
		}
		
		/**
		 * Handle an I/O Error
		 */
		public function onIOError(evt:IOErrorEvent):void
		{
			debugTrace("I/O Error: " + evt.text);
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
	                 debugTrace("Login Successful");
	                 sfs.getRoomList();
	                
	        }
	        else if (command == "logKO")
	        {
	               // Login Failed
	                debugTrace(data.err);
	        }
		}
			
		/**
		 * Trace messages to the debug text area
		 */
		
		public function debugTrace(msg:String):void
		{
			//ta_debug.text += "--> " + msg + NEWLINE;
			trace(msg);
		}
	}
			
}
