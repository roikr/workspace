package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class CloudsSoundsTest extends Sprite{
		
		 
		 public function CloudsSoundsTest() : void {
		 	
		 	SoundsLibrary.play(SoundsLibrary.SPACESHIP_LAND);
		 	SoundsLibrary.playMusic(SoundsLibrary.CLOUDS_MUSIC);
		}
	}
}
