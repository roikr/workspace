package {
	import flash.utils.Dictionary;
	/**
	 * @author roikr
	 */
	public class Order {
		
		private var layers:Array;
		private var tiles:Array;
		private var positions:Array;
		
		
		public function Order(xml:XML) {
			layers = new Array;
			tiles = new Array;
			positions = new Array;
			
			
			
			for each (var item:XML in xml.item ) {
				var tileXML : XML = item.tile[0];
				
				for (var i:uint = 0; i<tiles.length;i++) {
					if (tiles[i] is TileOrder) {
						var tile:TileOrder = tiles[i] as TileOrder;
					
						if (tile.isEqual(tileXML))  {
							positions.push(new TilePosition(item.@row,item.@column,i));
							tile.count++;
							break;
						}
					}
				}
					
				if (i==tiles.length) {
					tiles.push(new TileOrder(tileXML))
					positions.push(new TilePosition(item.@row,item.@column,i));
				}
						
				
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
			
			positions.sortOn(["id","row","column"], Array.NUMERIC);
			
			positions[0].bSource = true;
			
			for (var i:uint = 1; i<positions.length;i++) {
				positions[i].bSource = positions[i].id!=positions[i-1].id;	
			}

			positions.sortOn(["row", "column"], Array.NUMERIC);
			
			var counter:int = 1;
			for each (var pos:TilePosition in positions) {
				
				if (pos.bSource) {
					tiles[pos.id].id = counter;
					counter++;
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
			var desc:String = "tile\trow\tcolumn\tshape\tcolor\n";
			
			
			for each (var pos:TilePosition in positions) {
				
				if (pos.bSource) {
					desc += tiles[pos.id].id + '\t' + (pos.row+1) + '\t' + (pos.column+1) + '\n' + tiles[pos.id].describe() + '\n'
					
				}
				else {
					desc += '\t' + (pos.row+1) + '\t' + (pos.column+1) + "\tsame as tile "+tiles[pos.id].id+'\n'
					
				}
				
				
			}
			
			return desc;
		}
	}
}
