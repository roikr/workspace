package {
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class GridViewerTest extends Sprite {
			
		public function GridViewerTest() {
		
			addChild(new GridViewer(xml));
			var order:Order = new Order(xml);
			order.describe();
			trace(xml)
			
		}
			
		public function get xml() : XML {
			
			var xml:XML = <grid size="38" space="3">
  <item row="0" column="0">
    <tile>
      <layer color="100" shape="7"/>
      <layer color="100" shape="41"/>
    </tile>
  </item>
</grid>
			return xml;
		}
		
		
	}
}
