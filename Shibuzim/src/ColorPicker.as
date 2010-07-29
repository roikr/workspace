package {
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class ColorPicker extends ColorPickerMC {
		
		
		private var client:Object;
		private var bitmapData:BitmapData;
		private var _color:uint;
		
		
		public function ColorPicker(client:Object) {
			this.client = client;
			x = 10; //12 
			y = 392; //393
			bitmapData = new BitmapData(this.width,this.height,false);
			bitmapData.draw(this);
			
			/*
			for (var i:int=0;i<5;i++) {
				for (var j:int=0;j<10;j++) {
					graphics.beginFill(0xFF0000);
					graphics.drawRect(14*j, 14*i, 10, 10)
				}
			}
			 * 
			 */
			//this.buttonMode  = true;
			//this.useHandCursor = true;
			//this.alpha = 0.5;
			
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			
			_color  =bitmapData.getPixel(2,2);	
			//_colorPos = new Point(39,470); // not connected to display list yet
			
			
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			
			_color  =bitmapData.getPixel(e.localX,e.localY);	
			client.onClient(this);
			//trace(_colorPos);
		}
		
		public function get color () : uint {
			return _color;
		}
	}
}
