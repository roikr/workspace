package {
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class ColorPicker extends ColorPickerMC {
		
		
		//private var client:Object;
		private static var bitmapData:BitmapData;
		private var _color:uint;
		
		
		public function ColorPicker() {
			//this.client = client;
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
			
			_color = 100;
			//_color  =bitmapData.getPixel(2,2);	
			//_colorPos = new Point(39,470); // not connected to display list yet
			
			new SmartTooltip(this);
		}
		
		private function onMouseDown(e:MouseEvent) : void {
			var row:int = e.localY / 14;
			var column : int = e.localX /14;
			
			_color = 100 + row*10+column;
			if (_color > 124)
				_color += 77;
			
			trace(_color);
			
			//_color  =bitmapData.getPixel(e.localX,e.localY);	
			//client.onClient(this);
			//trace(_colorPos);
		}
		
		public function get color () : uint {
			
			
			return _color;
		}
		
		public static function getColor(color:uint) : uint {
			if (color>124)
				color-=77;
			color-=100;
			
			var row:int = color / 10;
			var column : int = color % 10;
			
			return bitmapData.getPixel(column*14+5,row*14+5);
		}
		
		public function getTooltipText(pnt:Point) : String {
			pnt = globalToLocal(pnt);
			
			
			var row:int = pnt.y / 14;
			var column : int = pnt.x /14;
			
			var color:int = 100 + row*10+column;
			if (color > 124)
				color += 77;
				
			return color.toString(); 
		}
	}
}
