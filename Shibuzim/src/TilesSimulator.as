package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

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
		private var service:ShibuzimService;
		private var tabs:Tabs;
		
		//private var _log:Log;
		private var videoPlayer:VideoPlayer;
		
		public function set log(str : String) : void {
			//_log.logArea.text += '\n' + str;
		}
		
		public function TilesSimulator() {
			addChild(bitmap);
			
			grids = new Array();
			addGrid(0);
			addGrid(1);
			addGrid(2);
			//grids.push(new Grid(this,0));
			//grids.push(new Grid(this,1));
			//grids.push(new Grid(this,2));
			currentGrid = grids[2] as Grid;
			addChild(currentGrid );
			addChild(toolsMenu=new ToolsMenu(this))
			
			addChild(tabs = new Tabs(this));
			addChild(tileEditor=new TileEditor(this));
			toolsMenu.tool = ToolsMenu.TOOLBAR_CURSOR;
					
			
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			
			
			
			//addChild(_log=new Log())
			
			var flashVars=this.loaderInfo.parameters;
			var nodeNum:Number = 0;
			if (flashVars.node) {
				nodeNum = Number(flashVars.node)
				//tf.text = node;
			}
			
			
			addChild(service = new ShibuzimService(this,nodeNum))
			
		}
		
		private function addGrid(type:int) : void {
			var grid = new Grid(type,this)
			grid.draw(new Point(209,75 + (473 - grid.gridHeight)/2))
			grids.push(grid);
		}
		
		
		
		public function onMouseUp(e:MouseEvent) : void {
			//trace(e.target,e.currentTarget)
			currentGrid.resetGrid(); // reset the magnifier scaling
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
			//trace(obj)
			if (obj is EditorPane || obj is ShapesPane) {
				/*
				if (tileEditor.tile.isSponge() && layer.isSpongeFiller()) {
					if (obj is EditorPane) {
						tileEditor.tile.addLayer(layer.shapeNum,layer.color,tileEditor.pane.getCorner());
					}
				} else {
				 * 
				 */
				
				tileEditor.addLayer(layer.shapeNum,layer.color)
				
				
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
						var order:Order =new Order(currentGrid.encode());
						
						/*
						trace(currentGrid.encode().toString());
						trace(order.describe_layers());
						trace(order.describe_tiles());
						 */
						
						service.code = currentGrid.encode().toString();
						service.partsList = order.describe_layers();
						service.tilesOrder = order.describe_tiles();
						service.show();
						break;
					case ToolsMenu.TOOLBAR_VIDEO:
						navigateToURL(new URLRequest("http://www.shibuzim.co.il/clip/help"),"_blank")
						//addChild(new VideoPlayer("help.f4v",this));
						break;
				}
				
				if (price) {
					price.price = (new Order(currentGrid.encode())).price;
				}
				
			} else if (obj is Grid) {
				if (toolsMenu.selectedTool == ToolsMenu.TOOLBAR_INK) {
					toolsMenu.tool = ToolsMenu.TOOLBAR_CURSOR;
				}
				
				if (price) {
					price.price = (new Order(currentGrid.encode())).price;
				}
			}
			else if (obj is Tabs) {
				changeGrid();
				
			} else if (obj is TileLayer) {
				startDragLayer(obj as TileLayer);
			} else if (obj is ShibuzimService) {
				
				var xml:XML = new XML(service.code);
				tabs.tab = xml.@type;
				
				var newGrid : Grid = (grids[tabs.tab]);
				newGrid.decode(xml);
				changeGrid();
			} else if (obj is VideoPlayer) {
				removeChild(obj as VideoPlayer);
				
			}
		}
		
		private function changeGrid() : void {
			var newGrid : Grid = (grids[tabs.tab]);
			if (newGrid!=currentGrid) {
					var index:int = this.getChildIndex(currentGrid);
					this.addChildAt(newGrid, index);
					this.removeChild(currentGrid);
					currentGrid = newGrid;
					
					if (price) {
						price.price = (new Order(currentGrid.encode())).price;
					}
				}
		}
		
		private function onPrice(e:MouseEvent) : void {
			price.removeEventListener(MouseEvent.MOUSE_DOWN,onPrice);
			removeChild(price);
			price = null;
			
		}

		public function get editor() : TileEditor {
			return tileEditor;	
		}
		
		
		
		
		public function get currentTool() : int {
			return toolsMenu.selectedTool;
		}
		
		
		
		
	}
}
