﻿package {	import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.display.SimpleButton;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.utils.Dictionary;	public class EarthMap extends EarthMapMC {				private var client:Object;		private var dict:Dictionary;		private var dest:String;						public function EarthMap(client:Object) : void {			this.client = client;			dict = new Dictionary();			for (var i:int = 0;i<mcEarth.numChildren ;i++) {				var obj:DisplayObject = mcEarth.getChildAt(i);				if (obj is SimpleButton) {					obj.addEventListener(MouseEvent.ROLL_OVER,onRollOver);					obj.addEventListener(MouseEvent.ROLL_OUT,onRollOut);					obj.addEventListener(MouseEvent.MOUSE_DOWN, onClick);					var str:String = obj.name.slice(1);					var child:MovieClip = mcEarth.getChildByName("mc"+str) as MovieClip;					/*					if (child)						trace(child.name);					else						trace(str);					*/										child.alpha = 0.25;					dict[obj]=child;					//trace(str);				}			}						bMoon.addEventListener(MouseEvent.MOUSE_DOWN,onClick)					//mcAfrica.visible = false;			SoundManager.playSound(WorldSounds.FLAME_LOOP_SOUND,null,false,true);				}												private function onRollOver(e:Event) : void {			(dict[e.target] as DisplayObject).alpha = 1;		}				private function onRollOut(e:Event) : void {			(dict[e.target] as DisplayObject).alpha = 0.25;		}				private function onClick(e:Event) : void {			dest = (e.currentTarget.name).substring(1);			//trace(dest);			SoundManager.playSound(WorldSounds.BEEP1_SOUND);			this.mcSpaceShip.addEventListener(Event.ENTER_FRAME,onEnterFrame)			this.mcSpaceShip.gotoAndPlay("go");			SoundManager.stopSound(WorldSounds.FLAME_LOOP_SOUND);					}		private function onEnterFrame(e:Event) : void {			var mc:MovieClip = (e.currentTarget) as MovieClip;			if (mc.currentFrameLabel=="end") {				this.mcSpaceShip.removeEventListener(Event.ENTER_FRAME,onEnterFrame)				client.exit(this);					}								}				public function getDestination() : String {			return dest; // 		}	}}							