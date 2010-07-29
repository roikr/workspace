package {
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class ShapeTest extends Sprite {
		public function ShapeTest() {
			var s1:Sprite = new Shape4() as Sprite;
			var s2:Sprite = new Shape29() as Sprite; // (new Shape30()).getChildByName("shape") as Sprite;
			var sp:Sprite = new Sprite();
			sp.addChild(s1);
			sp.addChild(s2);
			trace(s1.opaqueBackground,s2.opaqueBackground,s1.hitTestObject(s2),RKUtilities.hitTest(s1, s2));
		}
	}
}
