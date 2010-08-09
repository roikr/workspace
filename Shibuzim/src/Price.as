package {
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Price extends PriceMC {
		public function Price() {
			
		}
		
		public function set price(_price:uint) : void {
			this.dtPrice.text = _price.toString(); 
		}
		
		
	}
}
