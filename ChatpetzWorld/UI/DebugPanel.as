package {
	import fl.data.SimpleCollectionItem;

	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * @author roikr
	 */
	public class DebugPanel {
		private var panel:DebugPanelAssets;
		private var client:Object;
		
		public function DebugPanel(panel:DebugPanelAssets,client:Object) {
			this.panel = panel;
			this.client = client;
			
			/*
			panel.ti_username.setFocus();
			panel.bt_login.addEventListener(MouseEvent.CLICK, onLoginBtClick);
			
			panel.bt_login.enabled = true;
			panel.ti_username.enabled = true;
			 * 
			 */
			panel.cbLog.selected = false;
			panel.cbVoices.selected = false;
			
			
			panel.ta_log.visible = false;
			panel.ta_trace.visible = false;
			
			panel.cbLog.addEventListener(Event.CHANGE, onLogChange);
			panel.cbVoices.addEventListener(Event.CHANGE,onVoicesChange);
			
			panel.list.addEventListener(Event.CHANGE,onListChange);
		}
		
		private function onLogChange(e:Event) : void {
			panel.ta_log.visible = panel.ta_trace.visible = panel.cbLog.selected;
		}

		private function onVoicesChange(e:Event) : void {
			
			ChatpetzBeeps.setTestChatpetz(panel.cbVoices.selected);
			
		}
		
		private function onListChange(e:Event) : void {
			var item:SimpleCollectionItem  = panel.list.selectedItem as SimpleCollectionItem;
			if (item) {
				ChatpetzBeeps.setMainChatpet(item.data);
				
			}
			
		}
		
		public function logMessage(txt:String):void
		{
			panel.ta_log.text += txt + "\n";
			
			setTimeout(function():void { panel.ta_log.verticalScrollPosition = panel.ta_log.maxVerticalScrollPosition; }, 100);
		}
		
		public function logTrace(txt:String):void
		{
			panel.ta_trace.text += txt + "\n";
			
			setTimeout(function():void { panel.ta_trace.verticalScrollPosition = panel.ta_trace.maxVerticalScrollPosition; }, 100); 
		}	
		
		
		/**
		 * GO button click handler.
		 * Connector component tries to establish a connection to SmartFoxServer.
		 */
		 /*
		private function onLoginBtClick(e:Event):void
		{
			//logTrace("Go button clicked; Connector will now load SmartFoxClient configuration and connect to SmartFoxServer");
			
			panel.bt_login.enabled = false;
			panel.ti_username.enabled = false;
			//myUsername = loginPanel.ti_username.text;
			
			//smartFox.connect(myIP);
		}
		
		 
		  */
	}
}
