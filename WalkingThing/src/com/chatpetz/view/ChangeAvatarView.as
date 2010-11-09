package com.chatpetz.view {
	import com.chatpetz.model.Character;

	import flash.display.SimpleButton;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class ChangeAvatarView extends Sprite {
		
		protected var asset:ChangeAvatarAsset;
		protected var _characters:Array;
		
		public function ChangeAvatarView() {
			trace("ChangeAvatarView created")
			addChild(asset=new ChangeAvatarAsset())
		}
		
		public function set characters(_characters:Array) : void {
			this._characters = _characters;
			
			for each (var chr:Character in _characters) {
			
				var sb:SimpleButton = asset[chr.skin];
				sb.mouseEnabled = chr.enabled;
			
			} 
			
		}
	}
}
