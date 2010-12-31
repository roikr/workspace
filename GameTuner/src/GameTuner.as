package {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * @author roikr
	 */
	public class GameTuner {
		
		
		private var _numSamples:int;
		private var _params:Array;
		private var _client:Object;
		
		public function GameTuner(client:Object) {
			_client = client;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,loadXML);
			loader.load(new URLRequest("params.xml"));
		}
		
		private function loadXML(e:Event) : void {
			 var xml:XML = new XML(e.target.data);
			
			_numSamples = int(xml.attribute("numSamples"));
			//trace(numSamples);
			_params = new Array;
			
			for each (var paramElement:XML in xml.children()) {
				_params.push(new Parameter(paramElement));
			}
			
			_client.onClient(this);
		}
		
		public function get numSamples() : int {
			return _numSamples;
		}
		
		public function paramValue(n:int,i:int) : Number {
			return (_params[n] as Parameter).samples[i];		
		}
	}
}
