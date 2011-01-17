package {

	/**
	 * @author roikr
	 */
	public class TileOrder {
		
		private var layers:Array;
		public var _price:uint;
		public var count:uint;
		
		public function TileOrder(xml:XML) : void {
			layers = new Array;
			var list:XMLList = xml.layer;
			
			for each(var layer:XML in list) {
				layers.push(new Layer(layer));
			}
			
			var x:uint;
			for (var i:int = 0;i<layers.length;i++) {
				x |= (layers[i] as Layer).type;
			}
			
			switch (x) {
				case 1:
				case 2:
					_price = 15;
					break;
				case 3:
				case 4:
					_price = 30;
					break;
				case 5:
				case 6:
					_price = 45;
					break;
				case 7:
					_price = 50;
					break
			}	
			count = 1;	
		}
		
		
		public function get price() : uint {
			return _price;
		}
		
		public function isEqual(xml:XML) : Boolean {
			var list:XMLList = xml.layer;
			if (list.length() != layers.length)
				return false;
			
			for each(var layerXML:XML in list) {
				for (var i:int = 0;i<layers.length;i++) {
					if ((layers[i] as Layer).isEqual(layerXML))
						break;
				}
				if (i==list.length())
					return false;
			}
			
			return true;
		}
		
		public function describe() : String {
			var desc:String = "";
			for each (var layer:Layer in layers) {
				desc+='\t'+layer.describe()+'\n';
			}
			
			return desc;
		}
	
		
	}
}
