package {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class QuestionSynthesizer {
		private var client:Game;
		private var state:int;
		private var answer:int;
		private var question:String;
		private var timer:Timer;
		
		
		public function  QuestionSynthesizer(question:int,client:Game) {
			this.client = client;
			this.question = "QUIZ_Q"+question.toString();
			
			timer = new Timer(500,1);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			state = 0;
			timer.start();
				
		}
		
		private function onTimer(e:Event) : void {
			timer.reset();
			switch (state) {
				case 0:
					SoundManager.playSound(this.question,this,true);	
					break;
				case 1:
					SoundManager.playSound(getAnswerString(answer),this,true);
					
					break;
				case 2:
					
					
					SoundManager.playSound(this.question+getAnswerString(answer),this,true);
					break;
			}
		}
		
		public function onSoundComplete(obj:Object) : void {
			
			switch (state) {
				case 0:
					state = 1;
					answer = 0;
						
					break;
				case 1:
					state = 2;
					break;
				case 2:
					state =1;
					answer++;
					
					break;
			}
			
			if (state==1 && answer == 4)
				client.onFinishQuestion();
			else 
				timer.start();
		}
		
		private function getAnswerString(answer:int) : String {
			var res:String;
			
			switch (answer) {
				case 0:
					res='A';
					break;
				case 1:
					res='B';
					break;
				case 2:
					res='C';
					break;
				case 3:
					res='D';
					break;
			}
			return res;
		}
		
		
	}
}
