package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class XMLTest extends Sprite {
		
		/*
		private static var states:XML = <states>
			<Empty>
				<Cloud goto="Cloud"/>
			</Empty>
		    <Cloud>
		      <Umbrella goto="CloudUmbrella"/>
		      <Rain goto="CloudRain"/>
		      <Rainbow goto="CloudRainbow"/>
		      <Cherry goto="CloudCherry"/>
		      <Choclate goto="CloudChoclate"/>
		    </Cloud>
		</states>;
		
		private static var meals:XML = <meals>
			<meal name="C"/>
			<meal name="CH"/>
			<meal name="CS"/>
			<meal name="CR"/>
			<meal name="CU"/>
			<meal name="CHR"/>
			<meal name="CHU"/>
			<meal name="CHRU"/>
			<meal name="CSR"/>
			<meal name="CSU"/>
			<meal name="CSRU"/>
			<meal name="CHSR"/>
			<meal name="CHSU"/>
			<meal name="CHSRU"/>
			<meal name="CSHR"/>
			<meal name="CSHU"/>
			<meal name="CSHRU"/>
		</meals>;
		 * 
		 */
		 
		private static var states:XML = <states>
			<current name="E">
				<next name="C"/>
			</current>
			<current name="C">
				<next name="CH"/>
				<next name="CS"/>
				<next name="CR"/>
				<next name="CU"/>
			</current>
			<current name="CH">
				<next name="CHS"/>
				<next name="CHR"/>
				<next name="CHU"/>
			</current>
			<current name="CS">
				<next name="CSH"/>
				<next name="CSR"/>
				<next name="CSU"/>
			</current>
			<current name="CR">
				<next name="CRU"/>
			</current>
			<current name="CU">
				<next name="CUR"/>
			</current>
			<current name="CHS">
				<next name="CHSR"/>
				<next name="CHSU"/>
			</current>
			<current name="CSH">
				<next name="CSHR"/>
				<next name="CSHU"/>
			</current>
			<current name="CHR">
				<next name="CHRU"/>
			</current>
			<current name="CHU">
				<next name="CHUR"/>
			</current>
			<current name="CSR">
				<next name="CSRU"/>
			</current>
			<current name="CSU">
				<next name="CSUR"/>
			</current>
			
			<current name="CHSR">
				<next name="CHSRU"/>
			</current>
			<current name="CHSU">
				<next name="CHSUR"/>
			</current>
			<current name="CSHR">
				<next name="CSHRU"/>
			</current>
			<current name="CSHU">
				<next name="CSHUR"/>
			</current>
		</states>
		
		public function XMLTest() {
			//var first:XML = states.current.(@name=="CHS")[0];
			//trace(first)
			//var second:XML = first.states.current.(@name=="CHS")[0];
			//trace(second);
			var xml:XML = states.current.(@name=="E")[0].next.(@name=="H")[0];
			trace(xml)
			//trace(states.child("Empty")[0].child("Cloud")[0].attribute("goto"));
			//trace(meals.child("meal")[0].attribute("name"),meals.child("meal").length());
		}
	}
}
