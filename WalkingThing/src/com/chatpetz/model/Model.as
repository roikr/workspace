package com.chatpetz.model {
	import org.robotlegs.mvcs.Actor;

	/**
	 * @author roikr
	 */
	public class Model extends Actor {
		
		private var _characters:Array;
		
		public function get characters() : Array {
			if (!_characters)
				initializeCharacters();
				
			return _characters;
	
		}
		
		protected function initializeCharacters() : void 
		{
			var pizz : Character = new Character("Pizz");
			var popo : Character = new Character("Popo");
			popo.enabled = true;
			var piff : Character = new Character("Piff");
			piff.enabled = true;
			var parpara : Character = new Character("Parpara");
			var pammy : Character = new Character("Pammy");
			var poggy : Character = new Character("Poggy");
			
			_characters = [pizz,popo,piff,parpara,pammy,poggy];
		}
	}
	
	
}
