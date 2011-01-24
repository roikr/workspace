package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	 
	
	
	 
	public class OrderTest extends Sprite {
		
		private var xml:XML = 
<grid size="38" space="3" type="2">
  <item row="0" column="0">
    <tile>
      <layer color="107" shape="5"/>
    </tile>
  </item>
  <item row="0" column="1">
    <tile>
      <layer color="107" shape="5"/>
    </tile>
  </item>
  <item row="0" column="2">
    <tile>
      <layer color="107" shape="5"/>
    </tile>
  </item>
  <item row="1" column="0">
    <tile>
      <layer color="116" shape="5"/>
    </tile>
  </item>
  <item row="1" column="1">
    <tile>
      <layer color="116" shape="5"/>
    </tile>
  </item>
  <item row="1" column="2">
    <tile>
      <layer color="116" shape="5"/>
    </tile>
  </item>
</grid>;
		
		public function OrderTest() {
			var order:Order =new Order(xml);
			trace(order.describe_layers());
			trace(order.describe_tiles());
		}
	}
}
