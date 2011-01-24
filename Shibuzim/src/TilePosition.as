package {
	/**
	 * @author roikr
	 */
	public class TilePosition {
		
		public var row:uint;
		public var column:uint;
		public var id:uint;
		public var bSource:Boolean;
		
		public function TilePosition(row:uint,column:uint,id:uint) : void {
			this.row = row;
			this.column = column;
			this.id = id;
			
		}
		
		/*
		public static function orderRowColumn(a, b):int 
		{ 
		    if (a.row < b.row) 
		    { 
		        return -1; 
		    } 
		    else if (a.row > b.row) 
		    { 
		        return 1; 
		    } 
		    else 
		    { 
		        if (a.column < b.column) 
			    { 
			        return -1; 
			    } 
			    else if (a.column > b.column) 
			    { 
			        return 1; 
			    } 
			    else 
			    { 
			        return 0; 
			    }  
		    } 
		} 
		 * 
		 */
		
	}
}
