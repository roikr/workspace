package com.chatpetz.speed {
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * @author roikr
	 */
	public class Animal extends MovieClip {
		
		private var bPlaying:Boolean;
		
		public function Animal() {
			bPlaying = false;
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		
		
		public function startAnimation() : void {
			if (!bPlaying) {
				gotoAndPlay("start");
				bPlaying = true;
			}
		}
		
		public function stopAnimation() : void {
			if (bPlaying) {
				gotoAndStop(1);
				bPlaying = false;
			}
		}
		
		public function onEnterFrame(e:Event) : void {
			if (bPlaying && currentFrame == 1) {
				bPlaying = false;
			}
		}
		
		
		
	}
}
