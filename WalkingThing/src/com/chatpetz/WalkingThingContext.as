package com.chatpetz {
	import com.chatpetz.controller.CreateRoomCommand;
	import com.chatpetz.model.Model;
	import com.chatpetz.view.ChangeAvatarMediator;
	import com.chatpetz.view.ChangeAvatarView;
	import com.chatpetz.view.RoomMediator;
	import com.chatpetz.view.RoomView;

	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author roikr
	 */
	public class WalkingThingContext extends Context {
		public function WalkingThingContext(contextView : DisplayObjectContainer = null, autoStartup : Boolean = true) {
			super(contextView, autoStartup);
		}
		
		override public function startup() : void {
			
			injector.mapSingleton(Model);
			
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, CreateRoomCommand,ContextEvent,true)
			
			
			mediatorMap.mapView(ChangeAvatarView,ChangeAvatarMediator);
			
			
			
			mediatorMap.mapView(RoomView, RoomMediator);
			mediatorMap.mapView(WalkingThing, ApplicationMediator);
			
			super.startup();
			
		}
	}
}
