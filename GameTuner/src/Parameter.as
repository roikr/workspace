package {
	/**
	 * @author roikr
	 */
	public class Parameter {
		
		public var name:String;
		public var minValue:Number;
		public var maxValue:Number;
		public var samples:Array;
		
		
		public function Parameter(xml:XML) {
			name = xml.@name;
			minValue = Number(xml.@minValue);
			maxValue = Number(xml.@maxValue);
			//trace(name,minValue,maxValue);
			
			samples = new Array;
			for each (var sampleElement:XML in xml.children()) {
				samples.push(sampleElement.@value);
			}
			
			//trace(samples.toString());
			
		}
		
	}
}
