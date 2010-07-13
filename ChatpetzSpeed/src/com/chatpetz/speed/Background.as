package com.chatpetz.speed{
	import flash.display.Sprite;

	/**
	 * @author roikr
	 */
	public class Background extends Sprite {
		
		private var sky:StripHolder;
		private var mountains:StripHolder;
		private var far:StripHolder;
		//private var farAnimals:AnimalsHolder;
		private var middle:StripHolder;
		private var near:StripHolder;
		//private var nearAnimals:AnimalsHolder;
		//private var riverAnimals:AnimalsHolder;
		private var river:StripHolder;
		private var second:StripHolder;
		private var first:StripHolder;
		
		
		public function Background() {
			
			addChild(sky = new StripHolder("Sky",0,0));
			addChild(mountains = new StripHolder("Mountains",127,0));
			addChild(far = new StripHolder("Far",20,1*1.5));
			//addChild(farAnimals = new AnimalsHolder(300,1.5*1.5,0));
			addChild(middle = new StripHolder("Middle",240,2*1.5));
			addChild(near = new StripHolder("Near",-20,3*1.5));
			//addChild(middleAnimals = new AnimalsHolder(350,3*1.5,1));
			//addChild(riverAnimals = new AnimalsHolder(435,4*1.5,2));
			addChild(river = new StripHolder("River",470,4*1.5));
			addChild(second = new StripHolder("Second",-51,6*1.5));
			addChild(first = new StripHolder("First",-51,7*1.5));
			
		}
		
		
	}
}
