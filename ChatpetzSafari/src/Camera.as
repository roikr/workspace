package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class Camera extends Sprite {
		
		public var cameraInterface:CameraInterface;
		
		private var data:BitmapData;
		private var zoom:Number;
		private var bitmap:Bitmap;
		private var focusSound:RKSound;
		private var focus:Number;
		private var photos:Array;
		private var animal:Animal;
		private var lastAnimal:Animal;
		private var maxPhotos:int;
		
		public function Camera(width:int,height:int,zoom:Number,maxPhotos:int) {
			data = new BitmapData(width,height,false);
			this.zoom = zoom;
			this.maxPhotos = maxPhotos;
			bitmap = new Bitmap(data);
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			addChild(bitmap);
			addChild(cameraInterface = new CameraInterface());
			cameraInterface.dtPhotos.text = "0/"+maxPhotos.toString();
			
			
			
			focus = 0;
			photos = new Array();
			animal = null;
			lastAnimal = null;
			
			
		}
		
		public function reset() : void {
			photos = new Array();	
		
		}
		
		public function look(background:Background) : void {
			
			animal = background.hitTest(this) as Animal;
			
			//if (animal)
			//	animal.startAnimation();
			
			if (animal) 
				focus +=0.05;
			else
				focus = 0;
			
			if (focus > 0 && focus < 1) {
				if	(focusSound==null || !focusSound.playing) {
					focusSound = SoundManager.playSound(SafariSounds.CAMERA_FOCUS_SOUND);
				}
			} else {
				if (focusSound!=null && focusSound.playing)
					focusSound.stop();	
			}
			
			focus = focus > 1 ? 1 : focus;
			
			var matrix:Matrix = new Matrix();
			
			var p:Point = new Point(stage.mouseX,stage.mouseY);
			p = parent.globalToLocal(p);
			
			matrix.translate(-p.x,-p.y);
			matrix.scale(zoom,zoom);
			matrix.translate(bitmap.width/2,bitmap.height/2);
			
			var myFilters:Array = new Array();
			
			if (focus <1) {
				var blurX:Number = (1-focus) * 20;
				var blurY:Number = (1-focus) * 20;
				var filter:BitmapFilter  = new BlurFilter(blurX, blurY, BitmapFilterQuality.LOW);
				
				myFilters.push(filter);
			}
			
			
			data.draw(background,matrix);
			bitmap.filters = myFilters;
		}
		
		public function snapshot() : Boolean {
			
			if (animal && animal == lastAnimal)
				return false;
				
			SoundManager.playSound(SafariSounds.CAMERA_SHOT_SOUND);
				
			
			
			var photoData : BitmapData = new BitmapData(data.width,data.height,false);
			photoData.draw(bitmap);
			var photo:Photo = new Photo(photoData);
			
			if (animal)
				photo.setData(focus, animal.distance(this), false);		
				
			photos.push(photo);	
			
			cameraInterface.dtPhotos.text = photos.length.toString() + "/" + maxPhotos.toString();
			
			lastAnimal = animal;
			
			return true;
		}
		
		public function getPhoto(x:int) : Photo {
			return x < photos.length  ? photos[x] as Photo : null;
		}
		
	
		public function getPhotos() : Array {
			return photos;	
		}
		
		public function getNumPhotos() : int {
			return photos.length;
		}
		
		
	}
}
