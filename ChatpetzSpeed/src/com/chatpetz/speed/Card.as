package com.chatpetz.speed{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author roikr
	 */
	public class Card {
		
	
		private var bChatpet:Boolean;
		private var animal:Animal;
		private var holder:CardHolder;
		private var name:String;
	
		
		
		
		public function Card(holder:CardHolder) {
			this.holder = holder;
			
			
			holder.useHandCursor = true;
			holder.buttonMode = true;
			holder.mouseChildren = false;
			
			holder.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			holder.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			holder.mouseEnabled = false;
		}

		private function onMouseOver(e:Event) : void {
			holder.gotoAndStop(2);
			animal.startAnimation();
		}
		
		private function onMouseOut(e:Event) : void {
			holder.gotoAndStop(1);
			animal.stopAnimation();
		}
		
		public function setAnimal(animalClassName:String,bChatpet:Boolean = false) : void {
			if (holder.photo.numChildren>0)
				holder.photo.removeChildAt(0);
			
			holder.mouseEnabled = true;
			holder.background.gotoAndStop(Math.floor(Math.random()*4)+1);
			this.bChatpet = bChatpet;
			name = animalClassName;
			var AnimalClassReference:Class = getDefinitionByName("com.chatpetz.speed::"+animalClassName) as Class;
													
			 animal = new AnimalClassReference() as Animal;
			 
			 holder.photo.addChild(animal);
		}
		
			
		public function isChatpetz() : Boolean {	
			return bChatpet;
		}
		
		public function getAnimalName() : String {
			//return getQualifiedClassName(animal);
			return name;
		}
		
		
		
	}
}
