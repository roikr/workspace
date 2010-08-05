package {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class CustomersManager {
		
		
		private var positions:Array;
		private var client:ChatpetzClouds;
		private var timer:Timer;
		
	
		public function CustomersManager(client:ChatpetzClouds,assets:ChatpetzCloudsAssets) : void {
			this.client = client;
			positions = new Array();
			positions.push(new Position(assets.mcPosition1));
			positions.push(new Position(assets.mcPosition2));
			positions.push(new Position(assets.mcPosition3));
			
		}
		
		public function start() : void {
			timer = new Timer(5000,0);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
		}
		
		public function stop() : void {
			timer.stop();
		}
		
		private function onTimer(e:Event) : void {
			if (Math.random() > 0.5) 
				fetch();
		}

		public function count() : int {
			var n:int = 0;
			for (var i:int=0;i<positions.length;i++)
				if (positions[i].customer)
					n++;
			return n;
		}
		
		public function fetch() : void {
			if (count()<positions.length){
				for (var i:int=0;i<positions.length;i++)
					if (!positions[i].customer) {
						positions[i].customer = new Customer(this,positions[i]);
						positions[i].customer.enter(Ingredient.randomMeal(),30000);
						//positions[i].customer.enter("CRU",10000);
						break;
					}
						
			}
		}
		
		public function hasFreePosition() : Boolean {
			return count() < positions.length;
		}
		
		public function test(bowl:BowlImage) : void {
			for (var i:int=0;i<positions.length;i++)
					if (positions[i].customer) {
						if (positions[i].customer.hitTest(bowl)) {
							if (positions[i].customer.serve(bowl.currentFrameLabel)) {
								client.cloudServed(true);
								
							} else
								client.cloudServed(false);
							
							break;
							
						}
					}
		
					
		}
		
		public function customerLeft(pos:Position) : void {
			pos.customer = null;
		}
		
		public function getClient():ChatpetzClouds {
			return client;
		
		}
	}
}
