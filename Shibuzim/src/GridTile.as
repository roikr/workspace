package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class GridTile extends Sprite {
		public function GridTile(tileSize:Number) {
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, tileSize, tileSize)
		}
	}
}
