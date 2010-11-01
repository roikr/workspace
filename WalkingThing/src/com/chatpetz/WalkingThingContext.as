package com.chatpetz {
	import com.chatpetz.controller.CreateRoomCommand;
	import com.chatpetz.view.Room;
	import com.chatpetz.view.RoomMediator;

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
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, CreateRoomCommand,ContextEvent,true)
			
			mediatorMap.mapView(Room, RoomMediator);
			super.startup();
		}
	}
}
