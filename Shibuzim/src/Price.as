package {
	import flash.text.TextFieldAutoSize;

	/**
	 * @author roikr
	 */
	public class Price extends PriceMC {
		public function Price() {
			this.dtPrice.autoSize = TextFieldAutoSize.RIGHT;
		}
		
		public function set price(_price:uint) : void {
			this.dtPrice.text = _price.toString() ;
			this.stPrefix.x = dtPrice.x - stPrefix.width-3.5;
		}
		
		
	}
}
