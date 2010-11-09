package com.chatpetz.view {
	import com.chatpetz.controller.UIEvent;
	import com.chatpetz.model.Model;

	import org.robotlegs.mvcs.Mediator;

	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class ChangeAvatarMediator extends Mediator {
		
		[Inject]
		public var view:ChangeAvatarView;
		
		[Inject]
		public var model:Model;
		
		override public function onRegister() : void 
		{
			view.characters = model.characters;
			eventMap.mapListener(view, MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent) : void 
		{
			if (event.target is SimpleButton)
				dispatch(new UIEvent(UIEvent.CHANGE_AVATAR_CLICKED,event.target.name));	
		}
	}
}
