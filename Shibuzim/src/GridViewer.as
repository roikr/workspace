package {
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class GridViewer extends Sprite {
			
		private var colorPicker:ColorPicker;
		
			
			
		
		public function GridViewer() {
		
			//addChild(new GridViewer(xml));
			//var order:Order = new Order(xml);
			//order.describe();
			//trace(xml)
			
			
			var flashVars=this.loaderInfo.parameters;
			var nodeNum:Number = 1071;
			if (flashVars.node) {
				nodeNum = Number(flashVars.node)
				//tf.text = node;
			}
			
			
			new ShibuzimService(this,nodeNum);
			
		}
		
		public function onClient(obj:Object) : void {
			if (obj is ShibuzimService) {
				
				var xml:XML = new XML((obj as ShibuzimService).code);
				
				colorPicker = new ColorPicker(); // we need to instanciate the bitmapData of it
				var grid:Grid = new Grid(xml.@type);
				grid.draw(new Point(0,0));
				grid.decode(xml);
				
				addChild(grid);
				
				scaleX = 0.45;
				scaleY = 0.45;
				
			}
		}
		
		public function set log(str:String) : void {
			//trace(str);
		}
		
			
	}
}
