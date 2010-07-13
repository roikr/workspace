package {
	import flash.events.TextEvent;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author roikr
	 */
	public class WorldUI extends WorldUIAssets {
		
		public var textTimer : Timer;
		public var emoticonTimer : Timer;
		private var world:ChatpetzWorld;
		
		public function WorldUI(world:ChatpetzWorld) {
			textTimer = new Timer(1000,1);
			textTimer.addEventListener(TimerEvent.TIMER,onTextTimer);
			
			emoticonTimer = new Timer(1000,1);
			emoticonTimer.addEventListener(TimerEvent.TIMER,onEmoticonTimer);
			
			this.world = world;
			
		}
		
		private function configureListener() : void {
			bCard.addEventListener(MouseEvent.MOUSE_DOWN,onCardDown);
			bText.addEventListener(MouseEvent.MOUSE_DOWN,onTextDown);
			bEmot.addEventListener(MouseEvent.MOUSE_DOWN,onEmoticonDown);
			Bfriends.addEventListener(MouseEvent.MOUSE_DOWN,onFriendsDown);
			bAvatar.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			
			bScrollRight.addEventListener(MouseEvent.MOUSE_DOWN,function(e:Event):void {world.scrollRight();});
			bScrollLeft.addEventListener(MouseEvent.MOUSE_DOWN,function(e:Event):void {world.scrollLeft();});
			
			bHome.addEventListener(MouseEvent.MOUSE_DOWN,function(e:Event):void {world.loadMap("Home");});
			bMoon.addEventListener(MouseEvent.MOUSE_DOWN,function(e:Event):void {world.loadMap("Moon");});
			bMap.addEventListener(MouseEvent.MOUSE_DOWN,function(e:Event):void {world.loadMap("Africa");});
			
			
			itChat.addEventListener(TextEvent.TEXT_INPUT,onTextInput);
			
			
		}
		
		private function onTextInput(e:TextEvent) : void {
			//trace(e.text);
			
			var charExp:RegExp = /[a-zA-z0-9| |?|!]/;   
            //var numExp:RegExp = /[0-9]/;
			e.preventDefault();
			
			var str:String = e.text;
			//trace(str.length,str.charCodeAt(0));
			
			if (charExp.test(str) ) { // || numExp.test(str)
				var res:String = itChat.text+str;
				itChat.text = res;
				                
           		itChat.setSelection(res.length + 1, res.length + 1);
			} else if ( str.charCodeAt(0) == 10 ) {
				world.sendMessage(itChat.text);
				this.itChat.text = "";
				itChat.setSelection(1,1);
			}  
			//trace(itChat.text);
			
		}

		
		
		public function open() : void {
			
			gotoAndPlay("open");
			
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onEnterFrame(e:Event) : void {
			if (this.currentLabel=="idle") {
				removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				configureListener();
			}
		}
		
		public function close() : void {
			gotoAndPlay("close");
		}

		private function onCardDown(e:Event) : void {
			mcChatpetzCard.gotoAndPlay("open");
			bCard.removeEventListener(MouseEvent.MOUSE_DOWN,onCardDown);
			mcChatpetzCard.mcPanel.bClose.addEventListener(MouseEvent.MOUSE_DOWN, onCardClose);
		}
		
		private function onCardClose(e:Event) : void {
			mcChatpetzCard.gotoAndPlay("close");
			bCard.addEventListener(MouseEvent.MOUSE_DOWN,onCardDown);
			mcChatpetzCard.mcPanel.bClose.removeEventListener(MouseEvent.MOUSE_DOWN, onCardClose);
		}
		
		private function onTextDown(e:Event) : void {
			mcTextsMenu.gotoAndPlay("open");
			bText.removeEventListener(MouseEvent.MOUSE_DOWN,onTextDown);
			for (var i:int = 1;i<7;i++) {
				var b:Object = mcTextsMenu.getChildByName("b"+i.toString());
				 
				b.addEventListener(MouseEvent.MOUSE_DOWN,onTextSelect);
				b.addEventListener(MouseEvent.MOUSE_OVER,onTextOver);
				b.addEventListener(MouseEvent.MOUSE_OUT,onTextOut);
			}
			textTimer.start();
		}
		
		private function closeText() : void {
			mcTextsMenu.gotoAndPlay("close");
			bText.addEventListener(MouseEvent.MOUSE_DOWN,onTextDown);
			for (var i:int = 1;i<7;i++) {
				var b:SimpleButton = mcTextsMenu.getChildByName("b"+i.toString()) as SimpleButton;
				b.removeEventListener(MouseEvent.MOUSE_DOWN,onTextSelect);
				b.removeEventListener(MouseEvent.MOUSE_OVER,onTextOver);
				b.removeEventListener(MouseEvent.MOUSE_OUT,onTextOut);
			}
		}
		
		private function onTextSelect(e:Event) : void {
			closeText();
		}
		
		private function onTextOut(e:Event) : void {
			
			textTimer.start();
		}
		
		private function onTextOver(e:Event) : void {
			
			textTimer.stop();
		}
		
		private function onTextTimer(e:Event) : void {
			closeText();
		}
		
		
		
		private function onEmoticonDown(event:Event) : void {
			mcEmoticonsMenu.gotoAndPlay("open");
			bEmot.removeEventListener(MouseEvent.MOUSE_DOWN,onEmoticonDown);
			for (var i:int = 1;i<11;i++) {
				var e:Object = mcEmoticonsMenu.getChildByName("e"+i.toString());
				 
				e.addEventListener(MouseEvent.MOUSE_DOWN,onEmoticonSelect);
				e.addEventListener(MouseEvent.MOUSE_OVER,onEmoticonOver);
				e.addEventListener(MouseEvent.MOUSE_OUT,onEmoticonOut);
			}
			emoticonTimer.start();
		}
		
		private function closeEmoticon() : void {
			mcEmoticonsMenu.gotoAndPlay("close");
			bEmot.addEventListener(MouseEvent.MOUSE_DOWN,onEmoticonDown);
			for (var i:int = 1;i<11;i++) {
				var e:SimpleButton = mcEmoticonsMenu.getChildByName("e"+i.toString()) as SimpleButton;
				e.removeEventListener(MouseEvent.MOUSE_DOWN,onEmoticonSelect);
				e.removeEventListener(MouseEvent.MOUSE_OVER,onEmoticonOver);
				e.removeEventListener(MouseEvent.MOUSE_OUT,onEmoticonOut);
			}
		}
		
		private function onEmoticonSelect(e:Event) : void {
			closeEmoticon();
		}
		
		private function onEmoticonOut(e:Event) : void {
			
			emoticonTimer.start();
		}
		
		private function onEmoticonOver(e:Event) : void {
			
			emoticonTimer.stop();
		}
		
		private function onEmoticonTimer(e:Event) : void {
			closeEmoticon();
		}
		
	
		private function onFriendsDown(e:Event) : void {
			mcFriendsCard.gotoAndPlay("open");
			Bfriends.removeEventListener(MouseEvent.MOUSE_DOWN,onFriendsDown);
			mcFriendsCard.mcPanel.bClose.addEventListener(MouseEvent.MOUSE_DOWN, onFriendsClose);
		}
		
		private function onFriendsClose(e:Event) : void {
			mcFriendsCard.gotoAndPlay("close");
			Bfriends.addEventListener(MouseEvent.MOUSE_DOWN,onFriendsDown);
			mcFriendsCard.mcPanel.bClose.removeEventListener(MouseEvent.MOUSE_DOWN, onFriendsClose);
		}
		
		private function onAvatarDown(e:Event) : void {
			mcSwitchAvatar.gotoAndPlay("open");
			bAvatar.removeEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			mcSwitchAvatar.mcPanel.bClose.addEventListener(MouseEvent.MOUSE_DOWN, onAvatarClose);
			new ChatpetzManager(mcSwitchAvatar.mcPanel.spChangeAvatar,world);
		}

		private function onAvatarClose(e:Event) : void {
			mcSwitchAvatar.gotoAndPlay("close");
			bAvatar.addEventListener(MouseEvent.MOUSE_DOWN,onAvatarDown);
			mcSwitchAvatar.mcPanel.bClose.removeEventListener(MouseEvent.MOUSE_DOWN, onAvatarClose);
		}
	}
}
