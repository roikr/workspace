package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class CloudsSoundsTest extends Sprite{
		
		 
		 public function CloudsSoundsTest() : void {
		 	
		 	SoundManager.playSound(CloudsSounds.SPACESHIP_LAND);
		 	SoundManager.playMusic(CloudsSounds.CLOUDS_MUSIC);
		}
	}
}
