package {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author roikr
	 */
	public class RKUtilities {
	
		// test two objects hit according to pixel information
		public static function hitTest(obj1:DisplayObject,obj2:DisplayObject) : Boolean {
			
			var data1:BitmapData = new BitmapData(obj1.width,obj1.height,true,0);
			var data2:BitmapData = new BitmapData(obj2.width,obj2.height,true,0);
			
			var rect1:Rectangle = obj1.getBounds(obj1);
			var matrix1:Matrix = new Matrix();
			matrix1.translate(-rect1.x, -rect1.y);
			data1.draw(obj1,matrix1);
			var p1:Point = new Point(obj1.x,obj1.y);
			p1 = obj1.parent.localToGlobal(p1);
			p1 = p1.add(new Point(rect1.x,rect1.y));
			
			var rect2:Rectangle = obj2.getBounds(obj2);
			var matrix2:Matrix = new Matrix();
			matrix2.translate(-rect2.x, -rect2.y);
			data2.draw(obj2,matrix2);
			var p2:Point = new Point(obj2.x,obj2.y);
			p2 = obj2.parent.localToGlobal(p2);
			p2 = p2.add(new Point(rect2.x,rect2.y));
			
			var result:Boolean = data1.hitTest(p1,255,data2,p2,255);
			data1.dispose();
			data2.dispose();
			
			return result;						
		}	
		

	}
	
}
