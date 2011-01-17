package {
	import flash.utils.Dictionary;
	/**
	 * @author roikr
	 */
	public class Order {
		
		private var layers:Array;
		private var tiles:Array;
		
		
		public function Order(xml:XML) {
			layers = new Array;
			tiles = new Array;
			
			var counter:int = 0;
			for each (var item:XML in xml.item ) {
				var tileXML : XML = item.tile[0];
				
				for (var i:uint = 0; i<tiles.length;i++) {
					if (tiles[i] is TileOrder) {
						var tile:TileOrder = tiles[i] as TileOrder;
					
						if (tile.isEqual(tileXML))  {
							tiles[counter] = i;
							tile.count++;
							break;
						}
					}
				}
					
				if (i==tiles.length)
					tiles.push(new TileOrder(tileXML))
						
				counter++;
				
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
		
		public function describe_layers() : String {
			var desc:String = "shape\tcolor\toccurrences\n";
			for each (var layer:Layer in layers)
				desc+=layer.describeAndCount()+'\n'
			
			return desc;
		}
		
		public function describe_tiles() : String {
			var desc:String = "tile\tshape\tcolor\n";
			var counter:int = 1;
			for each (var obj:Object in tiles) {
				
				if (obj is TileOrder) {
					desc+='\n'+counter+'\n'
					desc+=(obj as TileOrder).describe()+'\n';
				}
				else {
					var num:int = (obj as int)+1;
					desc+=counter + " same as tile "+num+'\n';
				}
				
				counter++;
			}
			
			return desc;
		}
	}
}
