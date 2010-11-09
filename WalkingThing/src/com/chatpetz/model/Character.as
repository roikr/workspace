package com.chatpetz.model {
	/**
	 * @author roikr
	 */
	public class Character {
		public var skin:String;
		public var enabled:Boolean;
		
		public function Character(skin:String)
		{
			this.skin = skin;
			this.enabled = false;
		}
	}
}
