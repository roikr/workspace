package {
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author roikr
	 */
	public class TileView extends Sprite {
		
		private var shape:uint;
		private var color:uint;
		
		
		public function TileView() {
			x = 6;
			y = 6;
		}
		
		/*
		public function addTile(tileName:String) : void {
			var Ref:Class = getDefinitionByName(tileName) as Class;
			//trace(describeType(Ref));
			var instance : Sprite = new Ref() as Sprite;
			addChild(instance);
		}*/
		
		
		public function addTile(shape:uint,color:uint) : void {
			
			if (this.numChildren)
				this.removeChildAt(0);
			
			var tile:TileLayer = new TileLayer(shape,color);
			tile.scaleX = 0.3;
			tile.scaleY = 0.3;
			addChild(tile);
			
			this.shape = shape;
			this.color = color;
			
				
		}
		
		public function removeTile(tileName:String) : void {
			for (var i:int = 0; i<numChildren;i++) {
				if (getQualifiedClassName(getChildAt(i)) == tileName) {
					removeChildAt(i);
					break;
				}
			}
		}
		
		public function doesTileExist(tileName:String) : Boolean {
			for (var i:int = 0; i<numChildren;i++) {
				if (getQualifiedClassName(getChildAt(i)) == tileName) {
					return true;
				}
			}
			return false;
		}
		
		public function cloneCurrentTile() : Sprite {
			return new TileLayer(shape,color);
			/*
			var sp:Sprite = new Sprite();
			for (var i:int = 0; i<numChildren;i++) {
				var Ref:Class = getDefinitionByName(getQualifiedClassName(getChildAt(i))) as Class;
				//trace(describeType(Ref));
				sp.addChild(new Ref() as Sprite);
			}
			return sp;
			 * 
			 */
		}
	}
}
