package {

	/**
	 * @author roikr
	 */
	public class Order {
		
		private var layers:Array;
		private var tiles:Array;
		
		public function Order(xml:XML) {
			layers = new Array;
			tiles = new Array;
			for each (var item:XML in xml.item ) {
				var tileXML : XML = item.tile[0];
				
				for (var i:uint = 0; i<tiles.length;i++) {
						var tile:TileOrder = tiles[i] as TileOrder;
						
						if (tile.isEqual(tileXML))  {
							tile.count++;
							break;
						}
					}
					if (i==tiles.length)
						tiles.push(new TileOrder(tileXML))
				
				for each(var layerXML:XML in item.tile[0].layer) {
					var j:uint;
					for (j = 0; j<layers.length;j++) {
						var layer:Layer = layers[j] as Layer;
						
						if (layer.isEqual(layerXML))  {
							layer.count++;
							break;
						}
					}
					if (j==layers.length)
						layers.push(new Layer(layerXML))
				}
			}
			
			
		}
		
		public function get price() : uint {
			var x:uint;
			for each (var tile:TileOrder in tiles)
				x+=tile.price * tile.count;
			return x;
			
		}
		
		public function describe() : String {
			var desc:String = "";
			for each (var layer:Layer in layers)
				desc+=layer.description()+'\n'
			
			return desc;
		}
	}
}
