package com.chatpetz.speed {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	/**
	 * @author roikr
	 */
	public class StripHolder extends MovieClip {
	
		private static var importer:Array = [
            Sky,
            Mountains,
            Far,
            Middle,
            Near,
            River,
            Second,
            First,
            
        ];
	
		private var layer0:Sprite;
		private var layer1:Sprite;
		private var velX:int;
		
		
		
		public function StripHolder(className:String, initY:int, velX:int) {
			
			
			var ClassReference:Class = getDefinitionByName("com.chatpetz.speed::"+className) as Class;
			
			layer0 = new ClassReference() as Sprite;
			layer0.y = initY;
			addChild(layer0);
			
			
			layer1 = new ClassReference() as Sprite;
			layer1.y = initY;
			layer1.x = layer1.width;
			addChild(layer1);
			
			this.velX = velX;
			
			//trace(className+' '+this.velX);
			
			
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		public function onEnterFrame(e:Event) : void{
			
			layer0.x -= velX;
			layer1.x -= velX;
			
			
			if (layer0.x+layer0.width < 0)
				layer0.x+=2*layer0.width;
				
			if (layer1.x+layer1.width < 0)
				layer1.x+=2*layer1.width;
		
		}
		
		
	}
}
