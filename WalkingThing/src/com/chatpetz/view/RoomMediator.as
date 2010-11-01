package com.chatpetz.view {
	import org.robotlegs.mvcs.Mediator;

	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class RoomMediator extends Mediator {
		
		[Inject]
		public var view:Room;
		
		public function RoomMediator() {
			
		}
		
		override public function onRegister() : void 
		{
			eventMap.mapListener(view, MouseEvent.CLICK, onClick)
		}
		
		protected function onClick(event:MouseEvent) : void 
		{
			
			if (view.walkableArea == event.target) {
				view.goto(event.localX);
			}
			
		}
	}
}
