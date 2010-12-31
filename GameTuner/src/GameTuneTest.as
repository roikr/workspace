package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class GameTuneTest extends Sprite {
		
		private var tuner:GameTuner;
		
		public function GameTuneTest() {
			tuner = new GameTuner(this);
			
		}
		
		public function onClient(obj:Object) : void {
			if (obj is GameTuner) {
				trace(tuner.numSamples);
				trace(tuner.paramValue(1, 1));
			}
		}
		
	}
}
