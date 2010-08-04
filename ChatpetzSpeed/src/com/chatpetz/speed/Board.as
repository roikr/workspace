package com.chatpetz.speed {
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * @author roikr
	 */
	public class Board extends Sprite {
		
		private static var importer:Array = [
           
            Bird,
            Eli1,
            Fish,
            Giraffe,
            Hipo,
            Lion,
            Monkey,
            Raccoon,
            Butterfly
            
           
        ];
        
       
        private static var animalsNames:Array = ["Bird","Eli1","Fish","Giraffe","Hipo","Lion","Monkey","Raccoon","Butterfly"];
        private static var animalsCodes:Array=[ChatpetzCodes.CARD_GAME_BIRD,ChatpetzCodes.CARD_GAME_ELEPHANT,ChatpetzCodes.CARD_GAME_FISH,ChatpetzCodes.CARD_GAME_GIRAFFE,
       											 ChatpetzCodes.CARD_GAME_HIPPO,ChatpetzCodes.CARD_GAME_LION,ChatpetzCodes.CARD_GAME_MONKEY,ChatpetzCodes.CARD_GAME_RACCOON,
       											 ChatpetzCodes.CARD_GAME_BUTTERFLY];
        
       
       private var numCards:int;
       private var cards:Array;
       private var boardInterface:BoardInterface;
       private var dict:Dictionary;
       private var currentCard:int;
		
		public function Board(numCards:int) {
			boardInterface = new BoardInterface();
			addChild(boardInterface);
			this.numCards = numCards;
			cards = new Array();
			
			dict = new Dictionary();
			
			for (var i:int = 0; i < numCards  ; i++) {
				var holder:CardHolder = boardInterface.getChildByName("card"+(i+1).toString()) as CardHolder;
				
				var card:Card = new Card(holder);
				dict["card"+(i+1).toString()] = card;
				cards.push(card);
				
			}
			
			/*
			for (var i:int = 0; i < boardInterface.numChildren ; i++) {
				if (boardInterface.getChildAt(i) is CardHolder) {
					trace(boardInterface.getChildAt(i).name);
				}
			}
			 
			 */
		}
		
		public function prepare(cardNum:int) : void {
			currentCard = cardNum;
			var tempNames:Array = new Array();
			
			for (var k:int = 0; k< animalsNames.length ; k++) 
				tempNames.push(animalsNames[k] as String);
			
			
			for (var i:int = 0; i < numCards  ; i++) {
				
				var j:int = Math.floor(tempNames.length*Math.random());
				(cards[i] as Card).setAnimal(tempNames[j],i==cardNum);
				tempNames.splice(j,1);
				
				
			}
			//boardInterface.dtAnimal.text = (cards[cardNum] as Card).getAnimalName();
			boardInterface.gotoAndPlay(2);
			
		}
		
		public function go() : void {
			boardInterface.mcClock.gotoAndPlay(2);
			SoundManager.playSound(SpeedSounds.CARDS_IN_SOUND)
		}

		
		
		public function testAnimal(holder:CardHolder) : Boolean {
			//trace((dict[holder.name] as Card).getAnimalName());
			return (dict[holder.name] as Card).isChatpetz();
		}
		
		public function clear() : void {
			
			//boardInterface.dtAnimal.text = "";
			boardInterface.gotoAndPlay("clear");
			
		}
		
		public function getAnimalCode() : int {
			var name:String = (cards[currentCard] as Card).getAnimalName();
			var index:int = animalsNames.indexOf(name);
			return animalsCodes[index];
		}
	}
}
