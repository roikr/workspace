package {
	import com.chatpetz.controller.RoomEvent;
	import com.chatpetz.view.RoomView;

	import org.robotlegs.mvcs.Mediator;

	/**
	 * @author roikr
	 */
	public class ApplicationMediator extends Mediator {
		
		[Inject]
		public var view:WalkingThing;
		
		
		override public function onRegister() : void 
		{
			eventMap.mapListener(eventDispatcher, RoomEvent.ROOM_CREATED, onRoomCreated);
			view.createUI();
		}
		
		protected function onRoomCreated (event:RoomEvent):void
   		{
        	view.setRoomView(event.payload as RoomView)		
   		}
	}
}
