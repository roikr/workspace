package {
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class Ingredient extends IngredientAsset {
		
		private static var ingredients:XML = <ingredients>
			<ingredient ingClass="Cloud" name="C"/>
			<ingredient ingClass="Cherry" name="H"/>
			<ingredient ingClass="Choclate" name="S"/>
			<ingredient ingClass="Umbrella" name="U"/>
			<ingredient ingClass="Rainbow" name="R"/>
			<ingredient ingClass="Rain" name="N"/>
		</ingredients>;
		
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
		
		private static var alternates:XML = <alternates>
			<meal name="CRU" alt="CUR"/>
			<meal name="CHRU" alt="CHUR"/>
			<meal name="CSRU" alt="CSUR"/>
			<meal name="CHSRU" alt="CHSUR"/>
			<meal name="CSHRU" alt="CSHUR"/>
		</alternates>;
		
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
			
			
		/*
		private static var states:XML = <states>
			<E>
				<Cloud goto="C"/>
			</E>
		    <C>
		      <Cherry goto="CH"/>
		      <Choclate goto="CS"/>
		      <Rainbow goto="CR"/>
		      <Umbrella goto="CU"/>
		    </C>
		    <CH>
		      <Choclate goto="CHS"/>
		      <Rainbow goto="CHR"/>
		      <Umbrella goto="CHU"/>
		    </CH>
		     <CHS>
		      <Rainbow goto="CHSR"/>
		      <Umbrella goto="CHSU"/>
		    </CHS>
		    <CHU>
		      <Rainbow goto="CHRU"/>
		    </CHU>
		    <CHR>
		      <Umbrella goto="CHRU"/>
		    </CHR>
		    
		    <CHSR>
		      <Umbrella goto="CHSRU"/>
		    </CHSR>
		    <CHSU>
		      <Rainbow goto="CHSRU"/>
		    </CHSU>
		     
		    <CS>
		      <Cherry goto="CSH"/>
		      <Rainbow goto="CSR"/>
		      <Umbrella goto="CSU"/>
		    </CS>
		    <CSH>
		      <Rainbow goto="CSHR"/>
		      <Umbrella goto="CSHU"/>
		    </CSH>
		    <CSU>
		      <Rainbow goto="CSRU"/>
		    </CSU>
		    <CSR>
		      <Umbrella goto="CSRU"/>
		    </CSR>
		     <CSHR>
		      <Umbrella goto="CSHRU"/>
		    </CSHR>
		    <CSHU>
		      <Rainbow goto="CSHRU"/>
		    </CSHU>	    
		    <CU>
		      <Rainbow goto="CRU"/>
		    </CU>
		    <CR>
		      <Umbrella goto="CRU"/>
		    </CR>
		    <CU>
		      <Rainbow goto="CRU"/>
		    </CU>
		</states>;
		 * 
		 */
		
		public function Ingredient(str:String,loc:Point) {
			var label:String = ingredients.ingredient.(@ingClass==str)[0].attribute("name");
			gotoAndPlay(label);
			x = loc.x;
			y = loc.y;
					
		}
		
		public static function randomMeal() : String {
			//trace(meals.child("meal")[0].attribute("name"),meals.child("meal").length());
			var meal:String = meals.child("meal")[Math.floor(meals.child("meal").length()*Math.random())].attribute("name");
			//trace(meal);
			return meal;
		}
		
		public function getNextBowlState(str:String) : String {
			
			var nextStr:String = str=="E" ? currentLabel : str+currentLabel;
			
			return states.current.(@name==str)[0].next.(@name==nextStr)[0] != null ? nextStr : null;
		}
		
		public static function getMealName(str:String) : String {
			var xml:XML = alternates.meal.(@alt==str)[0];
			return xml==null ? str : xml.attribute("name");
		}
		
		/*
		public function getNextBowlState(str:String) : String {
			var options:XML = states.child(str)[0];
			//trace(target.currentFrameLabel,options);
			if (options) {
				var child:XML = options.child(currentLabel)[0];
				//trace(bowl.currentFrameLabel,child);
				if (child) 
					return child.attribute("goto");
					
			}
			return null;
		}
		 * 
		 */
	}
}
