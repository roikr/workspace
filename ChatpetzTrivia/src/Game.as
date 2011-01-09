package {
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Game {
		
		private static const BEEP_STATE_IDLE:int = 0;
		private static const BEEP_STATE_ANSWER:int=1;
		private static const BEEP_STATE_HELP:int=2;
		
		private var beepState:int;
		
		private var game:GameMC;
		private var client:ChatpetzTrivia;
		private var currentSound:RKSound;
		private var currentQuestion:XML;
		
		private var rightAnswers:Array;
		private var wrongAnswers:Array;
		
		
		
		private var questions:XML = <questions>
    <question correct="0">
        <body>Who wrote the book Alice in Wonderland?</body>
        <answer>Lewis Carrol</answer>
        <answer>A. A. Milne</answer>
        <answer>C. S. Lewis</answer>
        <answer>Jabberwocky</answer>
    </question>
    <question correct="3">
        <body>What sport uses a table, a cue, and 15 balls?</body>
        <answer>Bowling</answer>
        <answer>Mouse back-riding</answer>
        <answer>Soccer</answer>
        <answer>Pool</answer>
    </question>
    <question correct="0">
        <body>What animal can run even a few hours after it was born?</body>
        <answer>Giraffe</answer>
        <answer>Chatpet</answer>
        <answer>Lion</answer>
        <answer>Cat</answer>
    </question>
    <question correct="0">
        <body>What is the fastest animal in the world?</body>
        <answer>Cheetah</answer>
        <answer>David Beckham</answer>
        <answer>Dog</answer>
        <answer>Another dog</answer>
    </question>
    <question correct="3">
        <body>What are the primary colors?</body>
        <answer>Brown, Blue and Black.</answer>
        <answer>Orange, Green and Purple</answer>
        <answer>Pink with little stars and glitter.</answer>
        <answer>Blue, Red and Yellow.</answer>
    </question>
    <question correct="0">
        <body>What animal in the Arctic can smell a seal from miles away?</body>
        <answer>Polar Bear</answer>
        <answer>Solar Bear</answer>
        <answer>Collar Bear</answer>
        <answer>Dollar Bear</answer>
    </question>
    <question correct="2">
        <body>How many continents are there in the world?</body>
        <answer>2,666</answer>
        <answer>13,000,001</answer>
        <answer>7</answer>
        <answer>7 and a half</answer>
    </question>
    <question correct="3">
        <body>What is glass made of?</body>
        <answer>Metal</answer>
        <answer>Windows</answer>
        <answer>Water</answer>
        <answer>Sand</answer>
    </question>
    <question correct="1">
        <body>What is Ketchup made of?</body>
        <answer>Red finger paint</answer>
        <answer>Red Tomatoes</answer>
        <answer>Red Peppers</answer>
        <answer>Red Balloons</answer>
    </question>
    <question correct="0">
        <body>What animal has three sets of eyelids?</body>
        <answer>Camel</answer>
        <answer>Cowell</answer>
        <answer>Aardvark</answer>
        <answer>Amoeba</answer>
    </question>
    <question correct="1">
        <body>What animal only moves for 5 minutes every day?</body>
        <answer>Politician</answer>
        <answer>Kuala</answer>
        <answer>Sloth</answer>
        <answer>Mermaid</answer>
    </question>
    <question correct="2">
        <body>What does the Anteater eat?</body>
        <answer>Aunts</answer>
        <answer>Rice</answer>
        <answer>Ants</answer>
        <answer>Snacks</answer>
    </question>
    <question correct="1">
        <body>What kind of flightless bird has a horn?</body>
        <answer>Ostrich with a glued horn</answer>
        <answer>Kazuar</answer>
        <answer>Penguin</answer>
        <answer>Superman</answer>
    </question>
    <question correct="2">
        <body>What kind of an animal is a dolphin?</body>
        <answer>Whale</answer>
        <answer>Fish</answer>
        <answer>Mammal. Like us!</answer>
        <answer>Sea bird</answer>
    </question>
    <question correct="0">
        <body>What kind of an animal is a bat?</body>
        <answer>Mammal. Like us!</answer>
        <answer>Bird</answer>
        <answer>Robot</answer>
        <answer>Rodent</answer>
    </question>
    <question correct="0">
        <body>How many weeks are in a year?</body>
        <answer>52</answer>
        <answer>1,200,298</answer>
        <answer>May</answer>
        <answer>A lot</answer>
    </question>
    <question correct="0">
        <body>What are the colors of Japan’s flag?</body>
        <answer>White and red</answer>
        <answer>Blue and black</answer>
        <answer>Greenish</answer>
        <answer>Off white</answer>
    </question>
    <question correct="1">
        <body>How many seconds are there in one minute?</body>
        <answer>59</answer>
        <answer>60</answer>
        <answer>2,909,258 and a half</answer>
        <answer>L</answer>
    </question>
    <question correct="0">
        <body>The rhino’s horn is made of…</body>
        <answer>Keratin, like hair and fingernails!</answer>
        <answer>Photons, like the light!</answer>
        <answer>Wood, like paper!</answer>
        <answer>Lava, like lava?</answer>
    </question>
    <question correct="3">
        <body>What language do they speak in Switzerland?</body>
        <answer>French</answer>
        <answer>German</answer>
        <answer>Romansh</answer>
        <answer>All of them! Weird…</answer>
    </question>
    <question correct="3">
        <body>What is the heaviest animal in the world?</body>
        <answer>A very fat bear</answer>
        <answer>Pink Whale</answer>
        <answer>Elephant</answer>
        <answer>Blue Whale</answer>
    </question>
    <question correct="0">
        <body>What is the world’s smallest dog?</body>
        <answer>Chihuahua</answer>
        <answer>Great Dane</answer>
        <answer>German Shepherd</answer>
        <answer>St. Bernard</answer>
    </question>
    <question correct="1">
        <body>Where in the world are Pyramids?</body>
        <answer>Israel</answer>
        <answer>Egypt</answer>
        <answer>Mars</answer>
        <answer>The mall</answer>
    </question>
    <question correct="1">
        <body>Where can you find the Eiffel Tower?</body>
        <answer>London, Germany</answer>
        <answer>Paris, France</answer>
        <answer>Berlin, Dorothy</answer>
        <answer>French, Fries</answer>
    </question>
    <question correct="2">
        <body>What is the oldest and tallest tree in the world?</body>
        <answer>The Joshua Tree</answer>
        <answer>The Treepazoid</answer>
        <answer>The Sequoia Tree</answer>
        <answer>Weeping Willow</answer>
    </question>
    <question correct="2">
        <body>What is 100 x 100?</body>
        <answer>A million</answer>
        <answer>A thousand</answer>
        <answer>Ten thousand</answer>
        <answer>Three</answer>
    </question>
    <question correct="2">
        <body>What animal lives in the sea and sleeps with one eye open?</body>
        <answer>Stingray</answer>
        <answer>Octopus</answer>
        <answer>Dolphin</answer>
        <answer>Yellow Submarine</answer>
    </question>
    <question correct="3">
        <body>Who are the four members of the Beatles?</body>
        <answer>Optimus Prime, Megatron, Soundwave and Bumblebee</answer>
        <answer>Donatello, Rafael, Leonardo and Michelangelo</answer>
        <answer>Simba, Nala, Scar and Mufasa</answer>
        <answer>John, Paul, George and Ringo</answer>
    </question>
    <question correct="2">
        <body>What’s the name of the first dog in space?</body>
        <answer>Scooby Doo</answer>
        <answer>Marmaduke</answer>
        <answer>Laika</answer>
        <answer>Beethoven</answer>
    </question>
    <question correct="3">
        <body>What do they eat in Italy?</body>
        <answer>Pizza</answer>
        <answer>Spaghetti</answer>
        <answer>Lasagna</answer>
        <answer>All of them!</answer>
    </question>
    <question correct="0">
        <body>In what country do people sometimes build their houses of rice?</body>
        <answer>China</answer>
        <answer>United States</answer>
        <answer>Atlantis</answer>
        <answer>Denmark</answer>
    </question>
    <question correct="0">
        <body>What’s the hottest pepper in the universe?</body>
        <answer>India’s Bhut Jolokia</answer>
        <answer>England’s Black Mamba Pepper</answer>
        <answer>Chile’s Bell Pepper</answer>
        <answer>Sweden’s Aard Yorn Fjord!</answer>
    </question>
    <question correct="2">
        <body>What is paper usually made of?</body>
        <answer>Glass</answer>
        <answer>Clouds</answer>
        <answer>Wood</answer>
        <answer>Chicken</answer>
    </question>
    <question correct="1">
        <body>What is the world’s biggest city?</body>
        <answer>New York, USA</answer>
        <answer>Tokyo, Japan</answer>
        <answer>Dublin, Ireland</answer>
        <answer>Emerald City, Land of Oz</answer>
    </question>
    <question correct="2">
        <body>Which one of these isn’t a taste?</body>
        <answer>Bitter</answer>
        <answer>Sweet</answer>
        <answer>Hot</answer>
        <answer>Salty</answer>
    </question>
    <question correct="2">
        <body>How many teeth do people usually have?</body>
        <answer>40</answer>
        <answer>4,000,000</answer>
        <answer>32</answer>
        <answer>2</answer>
    </question>
    <question correct="0">
        <body>What animal carries it’s cubs in a pocket?</body>
        <answer>Kangaroo</answer>
        <answer>Peach</answer>
        <answer>Elephant</answer>
        <answer>Skunk</answer>
    </question>
    <question correct="0">
        <body>What animal can live the longest?</body>
        <answer>Tortoise</answer>
        <answer>Butterfly</answer>
        <answer>Lion</answer>
        <answer>Ant-lion</answer>
    </question>
    <question correct="1">
        <body>Which of these numbers is an odd number?</body>
        <answer>2</answer>
        <answer>3</answer>
        <answer>10</answer>
        <answer>6</answer>
    </question>
    <question correct="1">
        <body>Who was the first man on the moon?</body>
        <answer>Buzz Lightyears</answer>
        <answer>Neil Armstrong</answer>
        <answer>Superdude</answer>
        <answer>Buzz Aldrin</answer>
    </question>
    <!--question>
        <body></body>
        <answer></answer>
        <answer></answer>
        <answer></answer>
        <answer></answer>
    </question-->
</questions>




		
		
		public function Game(game:GameMC,client:ChatpetzTrivia) {
			this.game = game;
			
			game.dtBody.text="";
			game.dtA.text = "";
			game.dtB.text = "";
			game.dtC.text = "";
			game.dtD.text = "";
			
			game.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			this.client = client;
			
			
			rightAnswers = new Array();
			rightAnswers.push(ChatpetzCodes.TRIVIA_GAME_RIGHT_ANSWER_1)
			
			rightAnswers.push(ChatpetzCodes.TRIVIA_GAME_RIGHT_ANSWER_6)
			
			wrongAnswers = new Array();
			wrongAnswers.push(ChatpetzCodes.TRIVIA_GAME_WRONG_ANSWER_1)
			
			wrongAnswers.push(ChatpetzCodes.TRIVIA_GAME_WRONG_ANSWER_5)
			
			
		}
		
		public function open(question:int) : void {
			beepState = BEEP_STATE_IDLE;
			
			var list:XMLList = questions.question;
			currentQuestion = questions.question[(question-1) % list.length()];
			game.gotoAndPlay("open");
			SoundManager.playSound(TriviaSounds.STONES_IN_SOUND);
			
			game.bA.addEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bB.addEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bC.addEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bD.addEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bHelp.addEventListener(MouseEvent.MOUSE_DOWN,onHelp);
			game.bSkip.addEventListener(MouseEvent.MOUSE_DOWN,onSkip);
			game.mcRight.gotoAndStop(1);
			game.mcWrong.gotoAndStop(1);
			
			
			
			//new QuestionSynthesizer(question,this)
			//SoundManager.playSound("QUIZ_Q1.mp3",this,true);
			
			currentSound = SoundManager.playSound("QUIZ_"+question.toString(),this,true);
			client.onFinishQuestion();
		}
		
		public function onSoundComplete(obj:Object) : void {
			
		}
		
		public function onFinishQuestion() : void {
			trace("finish question");
			
		}
		
		private function onAnswer(e:Event) : void {
			var answer:int;
			currentSound.stop();
			
			switch(e.currentTarget) {
				case game.bA:
					answer=0;
					break;
				case game.bB:
					answer=1;
					break;
				case game.bC:
					answer=2;
					break;
				case game.bD:
					answer=3;
					break;
			}
			
			if (answer==currentQuestion.@correct) {
				SoundManager.playSound(TriviaSounds.CORRECT_ANSWER_SOUND);
				SoundManager.playSound(TriviaSounds.RIGHT_SOUND);
				SoundManager.chooseAndPlayBeep(rightAnswers,this);
				
				game.mcRight.play();
				client.updateScore(true);
			} else {
				SoundManager.chooseAndPlayBeep(wrongAnswers,this);
				SoundManager.playSound(TriviaSounds.WRONG_ANSWER_SOUND);
				SoundManager.playSound(TriviaSounds.WRONG_SOUND);
				game.mcWrong.play();
				client.updateScore(false);
			}
			
			beepState = BEEP_STATE_ANSWER;
		}
		
		public function onBeepCompleted(obj:Object) : void {
			switch(beepState) {
				case BEEP_STATE_ANSWER:
					close();
					break;
			}
			
			beepState = BEEP_STATE_IDLE;
		}

		
		
		
		private function onHelp(e:Event) : void {
			beepState = BEEP_STATE_HELP;
			switch(int(currentQuestion.@correct)) {
				case 0:
				case 2:
					SoundManager.playBeep(ChatpetzCodes.TRIVIA_GAME_A_OR_C,this);
					break;
				case 1:
				case 3:
					SoundManager.playBeep(ChatpetzCodes.TRIVIA_GAME_B_OR_D,this);
					break;
			}
		}

		private function onSkip(e:Event) : void {
			close();
		}
		
		public function close() : void {
			beepState = BEEP_STATE_IDLE;
			currentSound.stop();
			game.dtBody.text="";
			game.dtA.text = "";
			game.dtB.text = "";
			game.dtC.text = "";
			game.dtD.text = "";
			game.gotoAndPlay("close");
			//SoundManager.playSound(TriviaSounds.STONES_OUT_SOUND);
			
			game.bA.removeEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bB.removeEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bC.removeEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bD.removeEventListener(MouseEvent.MOUSE_DOWN,onAnswer);
			game.bHelp.removeEventListener(MouseEvent.MOUSE_DOWN,onHelp);
			game.bSkip.removeEventListener(MouseEvent.MOUSE_DOWN,onSkip);
			
		}
		
		
		
		private function onEnterFrame(e:Event) : void {
			if (game.currentFrameLabel && game.currentFrameLabel=="update") {
				var xml:XML = currentQuestion; 
				game.dtBody.text=xml.body[0].toString();
				game.dtA.text = xml.answer[0].toString();
				game.dtB.text = xml.answer[1].toString();
				game.dtC.text = xml.answer[2].toString();
				game.dtD.text = xml.answer[3].toString();
				
			}
			
			if (game.currentFrameLabel && game.currentFrameLabel=="end") {
				//game.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				game.mcRight.gotoAndStop(1);
				game.mcWrong.gotoAndStop(1);
				client.nextQuestion();
				
			}
		}
	}
}
