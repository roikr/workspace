package com.chatpetz.controller {
	import com.chatpetz.view.Room;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author roikr
	 */
	public class CreateRoomCommand extends Command {
		
		override public function execute() : void {
			var room : Room = new Room();
			contextView.addChild(room);
		}
		
		
	}
}
