package com.chatpetz.view {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class Room extends Sprite {
		
		protected var asset:RoomAsset;
		protected var area:FloorAsset;
		protected var character:Character;
		
		
		
		public function Room() {
			trace ("Room created")
//			graphics.clear();
//			graphics.beginFill(0x000099);
//			graphics.drawRect(0, 0, 800, 600)
			addChild(asset = new RoomAsset())
			area = asset.mcWalkableArea;
			area.useHandCursor = true;
			area.buttonMode = true;
			character = new Character();
			area.addChild(character);
			character.x = area.mcEnterPoint.x;
			character.y = area.mcEnterPoint.y;
			
		}
		
		public function goto(x:int) : void {
			character.goto(x); 
		}
		
		
		
		public function get walkableArea() : Sprite {
			return area;
		}
		
	}
}
