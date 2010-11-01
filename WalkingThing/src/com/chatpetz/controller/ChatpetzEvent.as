package com.chatpetz.controller {
	import flash.events.Event;

	/**
	 * @author roikr
	 */
	public class ChatpetzEvent extends Event {
		
		public static const WALKABLE_AREA_CLICKED : String = "walkable_area_clicked"
		
		public function ChatpetzEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
