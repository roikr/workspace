package com.chatpetz.controller {
	import flash.events.Event;

	/**
	 * @author roikr
	 */
	public class UIEvent extends Event {
		
		public static const CHANGE_AVATAR_CLICKED : String = "change_avatar_clicked"
		
		public function UIEvent(type : String, payload:Object) {
			super(type);
			_payload = payload;
			
		}
		
		private var _payload:Object;
    
	    public function get payload ():Object
	    {
	        return _payload;
	    }
	    
	    override public function clone():Event
	    {
	        return new UIEvent(type, payload);
	    }
	}
}
