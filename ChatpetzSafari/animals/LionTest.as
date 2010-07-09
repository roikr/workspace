package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class LionTest extends Sprite {
		public function LionTest() {
			var animal:Animal = new Lion();
			animal.x = 200;
			animal.y = 200;
			addChild(animal);
			animal.startAnimation();
		}
	}
}
