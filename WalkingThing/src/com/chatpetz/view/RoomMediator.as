package com.chatpetz.view {
	import com.chatpetz.controller.UIEvent;
	import com.chatpetz.model.Model;

	import org.robotlegs.mvcs.Mediator;

	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class RoomMediator extends Mediator {
		
		[Inject]
		public var view:RoomView;
		
		[Inject]
		public var model:Model;
		
		public function RoomMediator() {
			
		}
		
		override public function onRegister() : void 
		{
			view.characters = model.characters;
			eventMap.mapListener(view, MouseEvent.CLICK, onClick);
			eventMap.mapListener(eventDispatcher, UIEvent.CHANGE_AVATAR_CLICKED, onChangeAvatar);
		}
		
		protected function onClick(event:MouseEvent) : void 
		{
			
			if (view.walkableArea == event.target) {
				view.goto(event.localX);
			}
		}
		
		protected function onChangeAvatar(event:UIEvent) : void {
			view.setCharacter(event.payload as String);
		}
	}
}
