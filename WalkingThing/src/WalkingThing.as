package {
	import com.chatpetz.WalkingThingContext;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class WalkingThing extends Sprite {
		
		protected var context:WalkingThingContext;
		
		public function WalkingThing() {
			this.context = new WalkingThingContext(this)
		}
	}
}
