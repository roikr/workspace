package com.chatpetz.controller {
	import com.chatpetz.view.RoomView;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author roikr
	 */
	public class CreateRoomCommand extends Command {
		
		
		override public function execute() : void {
			dispatch(new RoomEvent(RoomEvent.ROOM_CREATED, new RoomView()))

		}
		
		
	}
}
