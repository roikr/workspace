package {
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	/**
	 * @author roikr
	 */
	public final class GameTuner {
		
		
		private var _numSamples:int;
		private var _params:Array;
		private var _client:Object;
		private var timer:Timer;
		private var sampleNum :int;
		
		private static var instance:GameTuner = new GameTuner();


		public function GameTuner() {
			if( instance ) throw new Error( "Singleton and can only be accessed through GameTuner.getInstance()" );
		}
		
		public static function getInstance():GameTuner {
			return instance;
		}
	
		public function load(client:Object) : void {
			_client = client;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,loadXML);
			loader.load(new URLRequest("params.xml"));
		}
		
		private function loadXML(e:Event) : void {
			 var xml:XML = new XML(e.target.data);
			
			_numSamples = int(xml.attribute("numSamples"));
			trace("numSamples: ",_numSamples);
			var delay:int = int(xml.attribute("delay"));
			trace("delay: ",delay);
			timer = new Timer(delay,0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			//trace(numSamples);
			_params = new Array;
			
			for each (var paramElement:XML in xml.children()) {
				_params.push(new Parameter(paramElement));
			}
			
			_client.onClient(this);
		}
		
		public function start() : void {
			timer.reset();
			timer.start();
		}
		
		private function onTimer(e:Event) : void {
			trace("timer: ",timer.currentCount)
		}
		
		
		public function get numSamples() : int {
			return _numSamples;
		}
		
		public function paramValue(n:int,i:int) : Number {
			return (_params[n] as Parameter).samples[i];		
		}
		
		public function currentParamValue(n:int) : Number {
			var i:int = timer.currentCount < numSamples ? timer.currentCount : numSamples-1;
			return paramValue(n,i);
		}
	}
}
