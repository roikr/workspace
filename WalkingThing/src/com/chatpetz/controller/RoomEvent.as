package com.chatpetz.controller {
	import flash.events.Event;

	/**
	 * @author roikr
	 */
	public class RoomEvent extends Event {
		public static const ROOM_CREATED : String = "room_created"
		
		public function RoomEvent(type : String, payload:Object) {
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
	        return new RoomEvent(type, payload);
	    }
	}
}
