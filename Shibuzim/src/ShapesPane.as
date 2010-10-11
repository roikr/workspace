package {
	import flash.display.Graphics;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class ShapesPane extends Sprite {
		
		private var hit:Sprite;
		private var view:Sprite;
		
		public function ShapesPane() {
			
			hit = new Sprite();
			
			addChild(hit);
			view = new Sprite();
			addChild(view);
			
			view.alpha = 0.2;
			hit.alpha = 0.0;
			
			mouseChildren = false; // I need that the target of the mouseup event will be shapespane (simulator)
			hitArea = hit;
			
			//this.buttonMode  = true;
			//this.useHandCursor = true;
			//alpha = 0.0; // TODO: alpha for shapes menu
			//shapes.addEventListener(MouseEvent.CLICK,onMouseEvent);
		}
		
		public function updateBy(tile:Tile) : void {
			
			hit.graphics.clear();
			view.graphics.clear();
			
			var graphics:Graphics;
			
			var i:int;
			for (i=0;i<14;i++) {
				graphics = tile.canAdd(i) ? hit.graphics : view.graphics;
				
				graphics.beginFill(0x000000);
				graphics.drawRect(29*(i%5)+1, 29*int(i/5)+1, 24, 24)
				
			}
			
			for (i=0;i<14;i++) {
				graphics = tile.canAdd(i+14) ? hit.graphics : view.graphics;
				
				graphics.beginFill(0x000000);
				graphics.drawRect(29*(i%5)+1, 29*(3+int(i/5))+1, 24, 24)
				
			}
			
			for (i=0;i<9;i++) {
				graphics = tile.canAdd(i+28) ? hit.graphics : view.graphics;
				graphics.beginFill(0x000000);
				graphics.drawRect(29*(i%5)+1, 29*(6+int(i/5))+1, 24, 24)
				
			}
		}
	}
}
