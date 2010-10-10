package {
	import it.gotoandplay.smartfoxserver.SFSEvent;

	import de.polygonal.ds.Array2;

	import com.smartfoxserver.openspace.components.flash.OpenSpace;
	import com.smartfoxserver.openspace.engine.control.events.MapInteractionEvent;
	import com.smartfoxserver.openspace.engine.control.events.OpenSpaceEvent;
	import com.smartfoxserver.openspace.engine.model.avatar.Avatar;
	import com.smartfoxserver.openspace.shared.control.events.LoggerEvent;
	import com.smartfoxserver.openspace.shared.model.other.Trigger;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/*
	 * @author roikr
	 */
	public class ChatpetzWorld extends Sprite {
		
		private var client:ChatpetzClient; // smart fox server's client
		
		private static const BEEP_STATE_IDLE:int = 0;
		private static const BEEP_STATE_CONTROL:int = 1;
		private static const BEEP_STATE_ENTER_ROOM:int = 2;
		private static const BEEP_STATE_DESCRIBE:int = 3;
		
		private var beepState:int;
		
		
		
		
		private var loadCounter1:int;
		//private var loadCounter2:int;
		private var swfLibrariesAppDomain:ApplicationDomain;
		//private var inventoryItems:Array;
		//private var selectedItemDirIndex:int;
		private var nextCenteringCoords:Point;
		private var nextDir:int;
		private var tempLoaders:Array;
		//private var enabledDoor:String;
		//private var nextRoom:String;
		
		private var currentMap:String;
		private var worldUI:WorldUI;
		private var gameManager:GameManager;
		private var container:ContainerAsset;
		private var debugPanel:DebugPanel;
		public var openSpace:OpenSpace;
		private var bOpenSpaceInitialized:Boolean = false;
		private var avatarManager:AvatarManager;
		private var skinsNames : Array = ["boat","card","cave","door","earthSpaceShip","moonSpaceShip","freezer","home","cloud","shop","bug","tiger","giraffe","termites","board","creatureRoom"];
		private var avatar:Avatar;
		
		private var loadingMC:LoadingMC;
		
		public function ChatpetzWorld() {
			super();
			new BeepsImporter();
			
			client = new ChatpetzClient(this,"chatpetz")
			
			
			openSpace = new OpenSpace();
			openSpace.configPath = "config/OpenSpace_client.xml";
			openSpace.xtName="__$OpenSpace$__";
			openSpace.width = 890;
			openSpace.height = 500;
			openSpace.traceEnabled = true;
			
			container = new ContainerAsset();
			container.spWorldContainer.addChild(openSpace);
			debugPanel = new DebugPanel(container.spDebugPanel,this);
			
			avatarManager = new AvatarManager(this, openSpace);
			avatarManager.loadAvatarsLibrary()
		
			// Add an event listener to the RoomList to override the default behavior and load the maps properly
			//rl_maps.addEventListener(BitEvent.ROOM_CHANGE, onMapSelected);
			
			SoundManager.setLibrary("WorldSounds");
			
			landingPage();
			
			loadingMC = new LoadingMC();
		}
		
		
		
		private function landingPage() : void {
			var landingPage:LandingPage = new LandingPage();
			landingPage.bPlay.addEventListener(MouseEvent.MOUSE_DOWN, onLandingClick)
			addChild(landingPage);
		}
		
		private function onLandingClick(e:Event) : void {
			removeChild(e.currentTarget.parent);
			container.spMCContainer.addChild(new VideoPlayer("intro.f4v",this));
			
			addChild(container);
			addChild(worldUI = new WorldUI(this));
			addChild(gameManager = new GameManager(this,container));	
		}
		

		
		
		public function exit(obj:Object) : void {
			
			if (obj is VideoPlayer) {
				container.spMCContainer.removeChild(obj as DisplayObject);
				switch ((obj as VideoPlayer).getVideoName()) {
					case "intro.f4v" :
						container.spMCContainer.addChild(new LoginScreen(this));
						
						break;
				}
			} else if (obj is LoginScreen) {
				client.connect((obj as LoginScreen).getUser(),(obj as LoginScreen).getPwd())
				
				
				
			} else  if (obj is MoviePlayer) {
				
				switch ((obj as MoviePlayer).getMovieName()) {
					
					case "MoonToEarthMC" :
						container.spMCContainer.removeChild(obj as DisplayObject);
						playMC(new EarthMap(this));
						
						break;
					case "EarthToMoonMC" :
						container.spMCContainer.removeChild(obj as DisplayObject);
						trace('container: ' + (container));
						loadMap("Moon");
						break;
				}
			} else if (obj is EarthMap) {
				switch ((obj as EarthMap).getDestination()) {
					case "Moon" :
						loadMap("Moon");
						break;
					default:
						loadMap("Africa");
						break;
						
				}
				
			} else if (obj is Shop) {
				worldUI.open();
				loadMap("Moon");
			} else
				container.spMCContainer.removeChild(obj as DisplayObject);
		}
		
		
		public function onBeepCompleted(obj:Object) : void {
			switch (beepState) {
				case BEEP_STATE_CONTROL: 
					
					break;
			}
			
			beepState = BEEP_STATE_IDLE;
		}
		//-------------------------------------------------------
		// 1. Handle SmartFoxServer connection & login
		//-------------------------------------------------------
		
		/**
		 * On successfull connection, login is attempted.
		 */
		public function onServerConnection():void
		{
			
		}
		
		/**
		 * Connection lost event handler.
		 */
		public function onServerConnectionLost():void
		{
			logTrace("Connection lost");
			if (worldUI.getIsOpen())
				worldUI.close();
			if (container.spMCContainer.numChildren) {
				container.spMCContainer.removeChildAt(0);
			}
			container.spMCContainer.addChild(new LoginScreen(this));
			// Map & edit controls are reset in the OpenSpaceEvent.RESET event handler
		}
		
		/**
		 * Login event handler.
		 * On successfull login, nothing happens because we have to wait for the roomlist to be available.
		 */
		public function onServerLogin():void
		{
			
			container.spMCContainer.removeChildAt(0);
			
			//loginPanel.ti_username.text = evt.params.name;
			
			
		
			SoundManager.mainChatpet="PIFF";
		}
		
		/**
		 * On room list received, OpenSpace is initialized.
		 */
		public function onServerRoomListUpdate():void
		{
			logTrace("onServerRoomListUpdate");
			
			//bt_reload.enabled = true;
			//bt_reset.enabled = true;
			// Initialize OpenSpace
			if (!worldUI.getIsOpen()) {
				worldUI.open();
			}
			
			if (!bOpenSpaceInitialized) {
				initializeOpenSpace();
			}
			else
				loadMap("Moon");
			
			// This event also causes the RoomList to be populated
		}
		
		
		private function initializeOpenSpace():void
		{
				
			openSpace.addEventListener(OpenSpaceEvent.INITIALIZED, onOpenSpaceInitialized);
			openSpace.addEventListener(OpenSpaceEvent.RESET, onOpenSpaceReset);
			openSpace.addEventListener(OpenSpaceEvent.MAP_LOADED, onOpenSpaceMapLoaded);
			openSpace.addEventListener(OpenSpaceEvent.MAP_CREATION_PROGRESS, onOpenSpaceMapProgress);
			openSpace.addEventListener(OpenSpaceEvent.MAP_RENDERED, onOpenSpaceMapRendered);
			openSpace.addEventListener(OpenSpaceEvent.MAP_ERROR, onOpenSpaceMapError);
			//openSpace.addEventListener(OpenSpaceEvent.INVENTORY_LOADED, onOpenSpaceInventoryLoaded);
			//openSpace.addEventListener(OpenSpaceEvent.INVENTORY_ERROR, onOpenSpaceInventoryError);
			//openSpace.addEventListener(OpenSpaceEvent.EDIT_MODE_ENTERED, onEditModeEntered);
			//openSpace.addEventListener(OpenSpaceEvent.EDIT_MODE_LEFT, onEditModeLeft);
			//openSpace.addEventListener(OpenSpaceEvent.MAP_ITEM_SELECTED, onMapItemSelected);
			//openSpace.addEventListener(OpenSpaceEvent.MAP_ITEM_DESELECTED, onMapItemDeselected);
			//openSpace.addEventListener(OpenSpaceEvent.MAP_ITEM_ADDED, onMapItemAdded);
			//openSpace.addEventListener(OpenSpaceEvent.MAP_ITEM_REMOVED, onMapItemRemoved);
			//openSpace.addEventListener(OpenSpaceEvent.MAP_UPDATED, onMapUpdated);
			
			//openSpace.addEventListener(MapInteractionEvent.TILE_CLICK, onTileInteraction);
			//openSpace.addEventListener(MapInteractionEvent.TILE_ROLL_OVER, onTileInteraction);
			//openSpace.addEventListener(MapInteractionEvent.TILE_ROLL_OUT, onTileInteraction);
			openSpace.addEventListener(MapInteractionEvent.SKIN_CLICK, onSkinInteraction);
			openSpace.addEventListener(MapInteractionEvent.SKIN_ROLL_OVER, onSkinInteraction);
			openSpace.addEventListener(MapInteractionEvent.SKIN_ROLL_OUT, onSkinInteraction);
			
			//openSpace.addEventListener(AvatarEvent.ENTER_TILE, onAvatarEnterTile);
			//openSpace.addEventListener(AvatarEvent.LEAVE_TILE, onAvatarLeaveTile);
			//openSpace.addEventListener(AvatarEvent.STOP_MOVEMENT, onAvatarStopOverTile);
			
			openSpace.addEventListener(LoggerEvent.INFO, onLoggerEvent);
			openSpace.addEventListener(LoggerEvent.WARNING, onLoggerEvent);
			openSpace.addEventListener(LoggerEvent.ERROR, onLoggerEvent);
			
			openSpace.init(client.smartFox); //, null);
			
			
			
			//worldInterface.configureListener();
		}
		
		public function scrollRight()  : void{
			openSpace.panView(400, 0);
		}
		
		public function scrollLeft() : void {
			openSpace.panView(-400, 0);
		}
		
		
		/**
		 * Load a map passing the name of the corresponding SmartFoxServer room.
		 * The name of the map to load is contained in a specific room variable that will be red by the OpenSpace Extension.
		 */
		public function loadMap(sfsRoomToJoin:String):void
		{
			SoundManager.stopAllSounds();
			SoundManager.playSound(WorldSounds.DIP_WHITE_TRANS_SOUND);
			
			if (container.spMCContainer.numChildren)
				container.spMCContainer.removeChildAt(0);
			
			container.spMCContainer.addChild(loadingMC);
			loadingMC.gotoAndStop(1);
			
			// Load map
			currentMap = sfsRoomToJoin;
			
			switch (currentMap) {
				case "Moon":
					
					break;
				case "Africa":
					
					
					
					break;
			}
			
			if (SoundManager.playMainChatpetBeep(this))
				beepState = BEEP_STATE_CONTROL;
			
			openSpace.loadMap(sfsRoomToJoin);
			
			
		}
		
		public function unloadMap():void
		{
			// Unload map
			
			openSpace.unloadMap();
		}
		
		public function getBack() : void {
			openSpace.loadMap(currentMap);
			worldUI.open();
		}
		
		//-----------------------------------------------
		// OpenSpace events handlers
		//-----------------------------------------------
		
		/**
		 * Logger event: trace logged informations in the application console.
		 */
		private function onLoggerEvent(evt:LoggerEvent):void
		{
			logMessage("[" + evt.type.toUpperCase() + "] " + evt.params.message + (evt.params.code != undefined ? " (" + evt.params.code + ")" : ""));;
		}
		
		/**
		 * OpenSpace initialization completed; nothing to do.
		 */
		private function onOpenSpaceInitialized(evt:OpenSpaceEvent):void {
			bOpenSpaceInitialized = true;
			logTrace("OpenSpace.INITIALIZED event received");
			loadMap("Moon");
		}
		
		/**
		 * OpenSpace reset: update application interface accordingly.
		 */
		private function onOpenSpaceReset(evt:OpenSpaceEvent):void
		{
			logTrace("OpenSpace.RESET event received");
			
		}
		
		/**
		 * Map generation progress event: trace generation percentage.
		 */
		private function onOpenSpaceMapProgress(evt:OpenSpaceEvent):void
		{
			logTrace("Map generation progress: " + evt.params.percentage + "%");
			loadingMC.gotoAndStop(evt.params.percentage);
		}
		
		/**
		 * Map loaded, but not yet rendered; bfore rendering the map we have to load the skins and backgrounds.
		 * We create the avatar now, so it will fade-in together with all the other avatars on map rendering completion.
		 * We could also create it after rendering.
		 * The nextCenteringCoords parameter is no null when the map loading is caused by a map interaction (a click on a door for example).
		 */
		private function onOpenSpaceMapLoaded(evt:OpenSpaceEvent):void
		{
			logTrace("Map loaded, now assets swf files can be loaded");
			
			/*
			// Create avatar (it will be displayed on map rendering only)
			//var tmp1:DemoAvatar;	// needed to include class in current app domain
			//var tmp2:DemoGhost;	// needed to include class in current app domain
			var tmp:ChatpetAvatar;
			
			var params:AvatarCreationParams = new AvatarCreationParams();
			params.type = "chatpet";
			params.centerViewport = true;
			
			if (nextCenteringCoords != null)
			{
				params.px = nextCenteringCoords.x;
				params.py = nextCenteringCoords.y;
				params.direction = nextDir;
			}
			
			try {
				openSpace.createMyAvatar(params);
			}
			catch (e:Error) {
				logTrace("AVATAR CREATION ERROR: " + e.message);
			}
			
			nextCenteringCoords = null;
			 * 
			 */
			 
			 avatarManager.createPlayerAvatar(nextCenteringCoords, nextDir)
			
			// Load map assets swf libraries
			loadMapAssets(evt.params.skinSwfFiles, evt.params.backgroundSwfFiles);
		}
		
		/**
		 * Map generation error: trace error message.
		 */
		private function onOpenSpaceMapError(evt:OpenSpaceEvent):void
		{
			logTrace("OpenSpace.MAP_ERROR event received:");
			logTrace(evt.params.code + " - " + evt.params.message);
		}
		
		/**
		 * Map rendering completed: nothing to do except updating application interface.
		 */
		private function onOpenSpaceMapRendered(evt:OpenSpaceEvent):void
		{
			avatar = openSpace.getMyAvatar();
			/*
			trace(getQualifiedClassName(avatar))
			trace(describeType(avatar).toString())
			
			var avatar2:Avatar = getMyAvatar();
			*/
			if (container.spMCContainer.numChildren)
				container.spMCContainer.removeChildAt(0);
			
			
			logTrace("OpenSpace.MAP_RENDERED event received");
			openSpace.mapScrollingEnabled = false;
			//if (viewStack.selectedChild!=openSpaceCanvas)
			//	viewStack.selectedChild = openSpaceCanvas;
			
			
			
			
			//var mc:MovieClip = openSpace.getSkinByName("caveTile", "caveSkin") as MovieClip;
			//if (mc)
			//	mc.gotoAndPlay(1);
			
			var code:int = 0;
			
			switch (currentMap) {
				case "Home":
					SoundManager.playMusic(WorldSounds.MOONBASE_MUSIC);
					code = ChatpetzCodes.WORLD_ENTER_ROOM;
					break;
				case "Moon":
					SoundManager.playMusic(WorldSounds.MOONBASE_MUSIC);
					code = ChatpetzCodes.WORLD_CLICK_MOON;
					break;
				case "Africa":
					code = ChatpetzCodes.WORLD_CLICK_AFRICA;
					SoundManager.playMusic(WorldSounds.AFRICA_MUSIC);
					break;
			}
			if (SoundManager.playBeep(code, this)) 
				beepState = BEEP_STATE_ENTER_ROOM
			
			
		}
		
		
		private function playGame(game:String) : void {
			worldUI.close();
			gameManager.load(game);
			unloadMap();
		}
		
		private function playMovie(movie:String) : void {
			container.spMCContainer.addChild(new MoviePlayer(movie,this));
		}
		
		public function playMC(mc:MovieClip) : void {
			container.spMCContainer.addChild(mc);
		}
		
		

		
		
		
		private function getMovieClipOnBackground(name:String) : MovieClip {
			var arr2:Array2 = openSpace.getBackgroundParts();
			if (!arr2)
				return null;
			var arr:Array = arr2.toArray();
			if (!arr)
				return null;
			var bk:DisplayObjectContainer = arr[0];
			
			var mc:MovieClip = bk.getChildByName(name) as MovieClip;
			
			if (mc==null) {
				arr2 = openSpace.getForegroundParts();
				if (!arr2)
					return null;
				arr= arr2.toArray();
				if (!arr)
					return null;
				var fg:DisplayObjectContainer = arr[0];
				mc = fg.getChildByName(name) as MovieClip;
			
			}
 			
			return mc
		}
		
		private function getMovieClipOnForeground(name:String) : MovieClip {
			var arr2:Array2 = openSpace.getForegroundParts();
			if (!arr2)
				return null;
			var arr:Array = arr2.toArray();
			if (!arr)
				return null;
			var bk:DisplayObjectContainer = arr[0];
			return bk.getChildByName(name) as MovieClip;
		}
		
		private function onSkinInteraction(evt:MapInteractionEvent):void
		{
			var skin:DisplayObject = evt.params.skin;
			var trigger:Trigger = evt.params.trigger;
			
			
			
			if (evt.type == MapInteractionEvent.SKIN_CLICK)
			{
				if (trigger.target == "moonSpaceShip") // Change map
				{
					playMovie("MoonToEarthMC")
					SoundManager.playSound(WorldSounds.SPACESHIP_TAKEOFF2_SOUND);
					unloadMap();	
				} else if (trigger.target == "earthSpaceShip") // Change map
				{
					playMovie("EarthToMoonMC")
					SoundManager.playSound(WorldSounds.SPACESHIP_TAKEOFF2_SOUND);
					unloadMap();
					
				} else if (trigger.target == "home") // Change map
				{
					loadMap("Home");
				} else if (trigger.target == "door") // Change map
				{
					loadMap("Moon");
				} else if (trigger.target == "boat") // Change map
				{
					playGame("games/Safari.swf");
					
				} else if (trigger.target == "card") // Change map
				{
					playGame("games/Speed.swf");
				} else if (trigger.target == "cloud") // Change map
				{
					playGame("games/ChatpetzClouds.swf");
				} else if (trigger.target == "cave") 
				{
					playGame("games/ChatpetzTrivia.swf");
				} else if (trigger.target == "freezer") // Change map
				{
					playMC(new Freezer(this));
					//var mc:MovieClip = openSpace.getSkinByName("feedmeTile", "feedmeSkin") as MovieClip;
					
					//mc.gotoAndPlay("open");
					
					//mc.mouseEnabled = true;
					//mc.mouseChildren = true;
				} else if (trigger.target == "shop") 
				{ 
					worldUI.close();
					playMC(new Shop(this));
					unloadMap();
				} else if (trigger.target == "board") // Change map
				{ 
					playMC(new Achievements(this));
				}
				else if (trigger.target == "giraffe") 
				{
					if (SoundManager.playBeep(ChatpetzCodes.AFRICA_CLICK_GIRAFFE,this))
						beepState = BEEP_STATE_DESCRIBE;
				} else if (trigger.target == "tiger") 
				{
					if (SoundManager.playBeep(ChatpetzCodes.AFRICA_CLICK_TIGER,this))
						beepState = BEEP_STATE_DESCRIBE;
						
				} else if (trigger.target == "termites") 
				{
					if (SoundManager.playBeep(ChatpetzCodes.AFRICA_CLICK_TERMITES,this))
						beepState = BEEP_STATE_DESCRIBE;
				} else if (trigger.target == "bug") 
				{
					trace("bug");
					if (SoundManager.playBeep(ChatpetzCodes.AFRICA_CLICK_BUG,this))
						beepState = BEEP_STATE_DESCRIBE;
				}  else if (trigger.target == "creatureRoom") 
				{
					if (SoundManager.chooseAndPlayBeep(new Array(ChatpetzCodes.WORLD_CLICK_MULTI_EYED_ALIEN_1,ChatpetzCodes.WORLD_CLICK_MULTI_EYED_ALIEN_2),this))
						beepState = BEEP_STATE_DESCRIBE;
					
				}
			
			} else if (evt.type == MapInteractionEvent.SKIN_ROLL_OVER)
			{
			
				if (skinsNames.indexOf(trigger.target)!=-1) {
					var mc1:MovieClip = getMovieClipOnBackground(trigger.target);
					//if (!mc1)
					//mc1 = skin as MovieClip;
					if (mc1) 
						mc1.gotoAndPlay("over"); 
					else
						trace(trigger.target+" not found")
				}
				
				switch (trigger.target) {
					case "door":
					case "shop":
						SoundManager.playSound(WorldSounds.DOOR_OPEN_SOUND,null,false,false,0.3);
						break;
					case "cloud":
						SoundManager.playSound(WorldSounds.CLOUDCREAM_ON_SOUND,null,false,false,0.3);
						break;
					case "freezer":
						SoundManager.playSound(WorldSounds.FRIDGE_OPEN_SOUND);
						SoundManager.playSound(WorldSounds.FRIDGE_LOOP_SOUND,null,false,true);
						break;
				}
				
				
				
			}
			else if (evt.type == MapInteractionEvent.SKIN_ROLL_OUT)
			{
				if (skinsNames.indexOf(trigger.target)!=-1) {
					var mc:MovieClip = (getMovieClipOnBackground(trigger.target) as MovieClip);
					if (mc)
						mc.gotoAndPlay("out");
					else
						trace(trigger.target+" not found")		
				}
					
				
				switch (trigger.target) {
					case "door":
					case "shop":
						SoundManager.playSound(WorldSounds.DOOR_CLOSE_SOUND,null,false,false,0.3);
						break;
					case "cloud":
						SoundManager.playSound(WorldSounds.CLOUDCREAM_OFF_SOUND,null,false,false,0.3);
						break;
					case "freezer":
						SoundManager.stopSound(WorldSounds.FRIDGE_LOOP_SOUND);
						SoundManager.playSound(WorldSounds.FRIDGE_CLOSE_SOUND);
				}
				
			}
			
			
			
			
			logTrace("\tTrigger target: " + trigger.target);
			logTrace("\tTrigger params: " + trigger.params);
		}
		
		
		
		
		
		
		//-----------------------------------------------
		// Private methods
		//-----------------------------------------------
		
		// ================ MAP SELECTION METHODS ================
		
		/**
		 * Room selected in the RoomList component: load the corresponding map.
		 */
		 /*
		private function onMapSelected(evt:BitEvent):void
		{
			var room:Room = evt.params.selectedRoom;
			
			// Load map
			loadMap(room.getName());
		}
		*/
		/**
		 * Load map graphical assets (skins and backgrounds). On load completion map just loaded will be rendered.
		 */
		private function loadMapAssets(skinSwfFilenames:Array, bgSwfFilenames:Array):void
		{
			/* IMPORTANT NOTE: for sake of simplicity, in this example both skins and backgrounds swf files are loaded in the same application domain.
			A number of improvements should be made:
			1) application domains should be kept separate between skins and backgrounds swf files, in order to avoid possible conflicts in case the class definitions they contain have the same names;
			2) in case the loaded map shares the same swf files of the previous map, reloading is unnecessary and should be avoided not to waste memory;
			3) if swf files for the previous map are not needed anymore, they should be unloaded. */
			
			swfLibrariesAppDomain = new ApplicationDomain();
			var fileNames:Array = skinSwfFilenames.concat(bgSwfFilenames);
			loadCounter1 = fileNames.length;
			tempLoaders = []; // We have to keep a reference to the loaders to avoid a bug in the Flash Player: http://bugs.adobe.com/jira/browse/FB-13014
			
			if (loadCounter1 > 0)
			{
				logTrace("External swf files to be loaded: " + fileNames);
				
				for (var i:int = 0; i < loadCounter1; i++)
				{
					var loader:Loader = new Loader();
					tempLoaders.push(loader);
					
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMapSwfFileLoaded);
					var url:String = "libraries/" + fileNames[i];
					var request:URLRequest = new URLRequest(url);
					var context:LoaderContext = new LoaderContext(false, swfLibrariesAppDomain);
					logTrace("loader created for "+ url);
					loader.load(request, context);
				}
			}
			else
				onMapSwfFileLoaded(null);
		}
		
		/**
		 * swf file loaded: when all the required swf files are loaded, map rendering can be launched.
		 */
		private function onMapSwfFileLoaded(evt:Event):void
		{
			loadCounter1--;
			logTrace("file loaded");
			if (loadCounter1 <= 0)
			{
				logTrace("External libraries loaded, now the loaded map can be rendered");
				
				// The same value is passed to both skinAppDomain and bgAppDomain parameters: check the comment to loadMapAssets method above.
				openSpace.skinAppDomain = swfLibrariesAppDomain;
				openSpace.bgAppDomain = swfLibrariesAppDomain;
				
				// Render map
				openSpace.renderMap();
				
				
			}
		}
		
		/**
		 * When a tile or skin trigger causes a map to be loaded, this method is called to retrieve the map name and destination coordinates.
		 * Then map loading is launched.
		 */
		private function loadMapFromTrigger(trigger:Trigger):void
		{
			var params:Array = trigger.params.split("|");
			var roomName:String = params[0];
			var coords:Array = params[1].split(",");
			var dir:int = params[2];
			if (coords.length == 2);
			{
				nextCenteringCoords = new Point(coords[0], coords[1]);
				nextDir = dir;
			}
			
			loadMap(roomName);
		}
		
		
		private function logMessage(txt:String):void
		{
			debugPanel.logMessage(txt);
			trace(txt)
		}
		
		public function logTrace(txt:String):void
		{
			debugPanel.logTrace(txt); 
			trace(txt)
		}	
		
		
		
		 // ================ AVATAR CONTROLS ================
		public function onAvatarDown(chatpet:String) : void {
			avatarManager.changePlayerAvatarSkin(chatpet);
			SoundManager.mainChatpet=chatpet;
			if (SoundManager.playMainChatpetBeep(this))
				beepState = BEEP_STATE_CONTROL;
			//ChatpetzBeeps.chooseAndPlay(new Array(ChatpetzCodes.WORLD_SWITCH_CHATPET,ChatpetzCodes.WORLD_USE_CHATPET));
		}

		public function sendMessage(msg:String) : void {
			client.sendMessage(msg);
		}
		
		public function getMyAvatar() : Avatar {
			//openSpace.getMyAvatar();
			//var ClassReference:Class = getDefinitionByName("com.smartfoxserver.openspace.engine.model.avatar::ChatpetzAvatar") as Class;
            //var instance:Object = new ClassReference();
			//var avatar:Avatar = new ClassReference() as Avatar;
			return avatar;
		}
		
		
	}
}
