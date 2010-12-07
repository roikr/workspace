package com.chatpetz.view {
	import com.chatpetz.model.Character;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	/**
	 * @author roikr
	 */
	public class CharacterView extends Sprite {
		
		protected var _step:Number;
		protected var asset:MovieClip;
		
		protected var destination:int;
		protected var bPositiveDir : Boolean;
		protected var bWalking:Boolean;
		protected var characterName:String;
		protected var importer:Array = [Pammy,Parpara,Piff,Pizz,Poggy,Popo];
		
		public function CharacterView(character:Character) {
			
			_step = 10;
			bWalking = false;
			currentCharacter = character;
		}
		
		public function set currentCharacter(character:Character) : void {
			characterName = character.skin;
			draw();
		}
		
		protected function draw() : void {
			if (asset) {
				removeChild(asset);
			}
			
			
			
			var ref:Class = getDefinitionByName(characterName) as Class
		
			addChild(asset = new ref() as MovieClip);
				
		}
		
		protected function startWalking() : void {
			asset.gotoAndPlay("walk");
			bWalking = true;
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		protected function stopWalking() : void {
			asset.gotoAndPlay("idle");
			bWalking = false;
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		public function goto(x:int) : void {
			if (!bWalking) {
				startWalking();
			}
			destination = x; 
			
			direction = destination > this.x;
			
		}
		
		protected function onEnterFrame(e:Event) : void {
			if (Math.abs(destination - x) > 10) {
				x+=  bPositiveDir ? _step : -_step;
			} else {
				stopWalking();
			}
		}
		
		protected function set direction(bPositiveDir:Boolean) : void {
			this.bPositiveDir = bPositiveDir;
			asset.scaleX = bPositiveDir ? 1 : -1;
		}
		
		public function get isWalking() : Boolean {
			return bWalking;
		}
		
		public function get isWalkingRight() : Boolean {
			return bPositiveDir;
		}
		
		public function get step() : Number {
			return _step;	
		}
		
	}
}