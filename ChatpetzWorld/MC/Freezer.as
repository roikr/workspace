package {
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Freezer extends FreezerMC {
		
		private var client:Object;
		
		public function Freezer(client:Object) {
			this.client = client;
			fridgeInAnim.bExit.addEventListener(MouseEvent.MOUSE_DOWN,onExit);
			fridgeInAnim.bUp.addEventListener(MouseEvent.MOUSE_DOWN,function () : void { SoundManager.playSound(WorldSounds.FRIDGE_UP_SOUND)});
			fridgeInAnim.bDown.addEventListener(MouseEvent.MOUSE_DOWN,function () : void { SoundManager.playSound(WorldSounds.FRIDGE_DOWN_SOUND)});
			gotoAndPlay("open")
			SoundManager.playSound(WorldSounds.FRIDGE_OPEN_SOUND);
			SoundManager.playSound(WorldSounds.FRIDGE_LOOP_SOUND,null,false,true);
		}

		private function onExit(e:Event) : void {
			fridgeInAnim.bExit.removeEventListener(MouseEvent.MOUSE_DOWN,onExit);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			SoundManager.stopSound(WorldSounds.FRIDGE_LOOP_SOUND);
			gotoAndPlay("close");
			SoundManager.playSound(WorldSounds.FRIDGE_CLOSE_SOUND);
		}

		private function onEnterFrame(e:Event) : void {
			if (this.currentFrame == 1) {
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				client.exit(this); 
				
			}
		}
	}
}
