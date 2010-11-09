package com.chatpetz.view {
	import com.chatpetz.model.Character;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class RoomView extends Sprite {
		
		protected var asset:RoomAsset;
		protected var area:FloorAsset;
		protected var characterView:CharacterView;
		protected var roomWidth:Number;
		
		
		protected static const STAGE_WIDTH : Number = 800;
		protected static const SCROLL_INDICATOR : Number = 300;
		
		protected var _characters:Array;
		
		
		public function RoomView() {
			trace ("RoomView created")
//			graphics.clear();
//			graphics.beginFill(0x000099);
//			graphics.drawRect(0, 0, 800, 600)
			asset = new RoomAsset()
			roomWidth = asset.width;
			addChild(asset)
			area = asset.mcWalkableArea;
			area.useHandCursor = true;
			area.buttonMode = true;
			
			
		}
		
		public function set characters(_characters:Array) : void {
			this._characters = _characters;
			
			setCharacter();
		}
		
		public function setCharacter(name:String = null) : void {
			
			
			if (!name) {
				for each (var chr:Character in _characters) {
					if (chr.enabled ) {
						characterView = new CharacterView(chr);
						break;
					}
				}
				
				
				characterView.x = area.mcEnterPoint.x;
				characterView.y = area.mcEnterPoint.y;
				area.addChild(characterView);
			}
			else {
				for each (var chr:Character in _characters) {
					if (chr.skin == name) {
						characterView.currentCharacter = chr;
						break;
					}
				}
			
			} 
				
				
			
			
			
		}
		
		public function goto(x:int) : void {
			characterView.goto(x); 
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame)
		}
		
		private function onEnterFrame(e:Event) : void {
			if (characterView.isWalking) {
				var chrPos:Point = this.globalToLocal(area.localToGlobal(new Point(characterView.x,characterView.y)))
				
				if (chrPos.x > STAGE_WIDTH - SCROLL_INDICATOR && characterView.isWalkingRight ) {
					if (asset.x + roomWidth > STAGE_WIDTH ) {
						asset.x-=characterView.step;
					}
				}
				
				if (chrPos.x < SCROLL_INDICATOR && !characterView.isWalkingRight) {
					if (asset.x < 0) {
						asset.x+=characterView.step;
					}
				}
			} else {
				removeEventListener(Event.ENTER_FRAME,onEnterFrame)
			}
		}
		
		
		
		public function get walkableArea() : Sprite {
			return area;
		}
		
	}
}
