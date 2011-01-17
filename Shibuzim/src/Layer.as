package {

	/**
	 * @author roikr
	 */
	public class Layer {
		private var shape:uint;
		private var color:uint;
		public var type:uint;
		public var count:uint;
		
		public static const OUTER:uint = 0x4;
		public static const MIDDLE:uint = 0x2;
		public static const INNER:uint = 0x1;
		
		
		public function Layer (xml:XML) {
			this.shape = xml.@shape;
			this.color = xml.@color;
			
			type = shape < 14 ? OUTER : shape < 30 ? MIDDLE : shape < 33 ? INNER : MIDDLE;
			count = 1;
		}
		
		public function isEqual(xml:XML) : Boolean {
			return shape==xml.@shape && color==xml.@color;
		}
		
		public function describeAndCount() : String {
			return shape+'\t'+color+'\t'+count; //count +" x [ " + shape + ", " + color + " ] ";
		}
		
		public function describe() : String {
			return shape+'\t'+color;
		}
	}
}
