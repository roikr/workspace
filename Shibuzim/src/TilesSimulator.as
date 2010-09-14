package {
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class TilesSimulator extends Sprite {
		
		[Embed(source='../assets/back_ground.png')]
        private var BackgroundPNG:Class;
        private var bitmap:Bitmap = new BackgroundPNG() ;
		
		private var grids:Array;
		private var currentGrid:Grid;
		private var tileEditor:TileEditor;
		private var toolsMenu:ToolsMenu;
		private var price:Price;
		private var layer:TileLayer;
		
		
		
		public function TilesSimulator() {
			addChild(bitmap);
			
			grids = new Array();
			grids.push(new Grid(this,22,2));
			grids.push(new Grid(this,27,3));
			grids.push(new Grid(this,38,3));
			currentGrid = grids[2] as Grid;
			addChild(currentGrid );
			addChild(toolsMenu=new ToolsMenu(this))
			
			addChild(new Tabs(this));
			addChild(tileEditor=new TileEditor(this));
			toolsMenu.tool = ToolsMenu.TOOLBAR_CURSOR;
			
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			
		}
		
		public function onMouseUp(e:MouseEvent) : void {
			//trace(e.target,e.currentTarget)
			currentGrid.resetGrid();
			if (layer) {
				stopDragLayer(e.target);
			}
		}
		
		public function startDragLayer(layer:TileLayer) : void {
			this.layer=layer;
			layer.scale = 0.3;
			addChild(layer);
			layer.x = stage.mouseX-460*0.3/2;
			layer.y = stage.mouseY-460*0.3/2;
			layer.startDrag();
		}
		
		public function stopDragLayer(obj:Object) : void {
			if (obj is EditorPane || obj is ShapesPane) {
				tileEditor.tile.applyLayer(layer,layer.color);
			}
			removeChild(layer);
			layer=null;
		}
		
		
		public function onClient(obj:Object) : void {
			if (obj is ToolsMenu) {
				
				switch (toolsMenu.immediateTool) {
					case ToolsMenu.TOOLBAR_GRID_ERASER:
					case ToolsMenu.TOOLBAR_GRID_FILLER:
					case ToolsMenu.TOOLBAR_UNDO:
						currentGrid.applyTool(toolsMenu.immediateTool)	
						break;
					case (ToolsMenu.TOOLBAR_COST) : 
						//trace(currentGrid.encode().toString());
						if (!price) {
							price = new Price();
							price.x = 860;
							price.y = 500;
							addChild(price);
							price.addEventListener(MouseEvent.MOUSE_DOWN, onPrice)
						}
						break;
					case (ToolsMenu.TOOLBAR_INVITATION) :
						(new Order(currentGrid.encode())).describe();
						trace(currentGrid.encode().toString());
						break;
				}
				
				if (price) {
					price.price = (new Order(currentGrid.encode())).price;
				}
				
			} else if (obj is Grid) {
				if (price) {
					price.price = (new Order(currentGrid.encode())).price;
				}
			}
			else if (obj is Tabs) {
				var newGrid : Grid = (grids[(obj as Tabs).tab]);
				if (newGrid!=currentGrid) {
					var index:int = this.getChildIndex(currentGrid);
					this.addChildAt(newGrid, index);
					this.removeChild(currentGrid);
					currentGrid = newGrid;
					
					if (price) {
						price.price = (new Order(currentGrid.encode())).price;
					}
				}
			} else if (obj is TileLayer) {
				startDragLayer(obj as TileLayer);
			}
		}
		
		private function onPrice(e:MouseEvent) : void {
			price.removeEventListener(MouseEvent.MOUSE_DOWN,onPrice);
			removeChild(price);
			price = null;
			
		}

		public function get tile() : Tile {
			return tileEditor.tile;	
		}
		
		public function set tile(tile:Tile) : void  {
			tileEditor.tile = tile;
		}
		
		
		
		public function get currentTool() : int {
			return toolsMenu.selectedTool;
		}
		
		
		
		
	}
}
