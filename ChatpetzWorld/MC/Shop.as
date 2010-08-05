package {
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Shop extends ShopMC {
		
		private var client:Object;
			
		public function Shop(client:Object) {
			this.client = client;
			bExit.addEventListener(MouseEvent.CLICK,onExit);
		}
		
		private function onExit(e:Event) : void {
			bExit.removeEventListener(MouseEvent.CLICK,onExit);
			client.exit(this);
			SoundManager.playSound(WorldSounds.SHOP_OFF_SOUND);
		}
	}
}
