package {
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class Album extends Sprite {
		
		public var bLeft:SimpleButton;
		public var bRight:SimpleButton;
		public var bPlayAgain:SimpleButton;
		public var photo:PhotoHolder;
		public var bitmap:Bitmap;
		public var feedback:AlbumFeedback;
		
		
		private var photos:Array;
		private var currentPhoto:int;
		
		public function Album() {
			bLeft.addEventListener(MouseEvent.CLICK,leftClicked);
			bRight.addEventListener(MouseEvent.CLICK,rightClicked);
			photo.addChild(bitmap = new Bitmap());
			currentPhoto = 0;
		}
		
		public function setPhotos(photos:Array) : void {
			this.photos = photos;
			update();
		}
		
		private function update() : void {
			bitmap.bitmapData = (photos[currentPhoto] as Photo).getBitmapData();
			feedback.dtPoints.text  =(photos[currentPhoto] as Photo).getScore().toString();
			feedback.gotoAndStop((photos[currentPhoto] as Photo).getFeedbackFrame());
		}
		
		private function leftClicked(e:Event) : void {
			if (currentPhoto > 0) {
				currentPhoto--;
				update();
			}
		}
		
		private function rightClicked(e:Event) : void {
			if (currentPhoto < photos.length-1) {
				currentPhoto++;
				update();
			}
		}
	}
}
