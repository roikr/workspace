package {
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import it.gotoandplay.smartfoxserver.SmartFoxClient;

	import de.polygonal.ds.Array2;

	import com.smartfoxserver.openspace.components.flash.OpenSpace;
	import com.smartfoxserver.openspace.engine.control.events.MapInteractionEvent;
	import com.smartfoxserver.openspace.engine.control.events.OpenSpaceEvent;
	import com.smartfoxserver.openspace.shared.control.events.LoggerEvent;
	import com.smartfoxserver.openspace.shared.model.other.Trigger;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * @author roikr
	 */
	public class ChatpetzWorld extends Sprite {
		
		
		private var myUsername:String;
		private var myIP:String;
		private var smartFox:SmartFoxClient;
		
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
		private var loginScreen:LoginScreen;
		
		public var openSpace:OpenSpace;
		
		private var bInitialized:Boolean;
		
		private var avatarManager:AvatarManager;
		
		private var skinsNames : Array = ["boat","card","cave","door","earthSpaceShip","moonSpaceShip","freezer","home","cloud","shop"];
		
		public function ChatpetzWorld() {
			super();
			init();
			
		}
		
		
		
		//-------------------------------------------------------
		// 0. Initialize
		//-------------------------------------------------------
		
		/**
		 * Method called on application startup.
		 * Event listeners are added to the SmartFoxClient instance provided by the Connector component.
		 */
		private function init():void
		{
			SoundManager.setLibrary("WorldSounds");
			new BeepsImporter();
			bInitialized = false;
			addChild(container = new ContainerAsset());
			MCPlayer.setContainer(container.spMCContainer);
			
			addChild(worldUI = new WorldUI(this));
			addChild(gameManager = new GameManager(this,container));
			debugPanel = new DebugPanel(container.spDebugPanel,this);
			
			
			
			openSpace = new OpenSpace();
			container.spWorldContainer.addChild(openSpace);
			openSpace.configPath = "config/OpenSpace_client.xml";
			openSpace.xtName="__$OpenSpace$__";
			openSpace.width = 890;
			openSpace.height = 500;
			
			openSpace.traceEnabled = true;
			
			// Create SmartFoxClient instance and register event listeners
			//smartFox = Connector.smartFox;
			smartFox = new SmartFoxClient();
			smartFox.addEventListener(SFSEvent.onConnection, onSFSConnection);
			smartFox.addEventListener(SFSEvent.onConnectionLost, onSFSConnectionLost);
			smartFox.addEventListener(SFSEvent.onLogin, onSFSLogin);
			smartFox.addEventListener(SFSEvent.onRoomListUpdate, onSFSRoomListUpdate);
			smartFox.defaultZone="chatpetz";
		
			
			//enableOSControls(false);
			//enableEditPanel(false);
			
			// Add an event listener to the RoomList to override the default behavior and load the maps properly
			//rl_maps.addEventListener(BitEvent.ROOM_CHANGE, onMapSelected);
			
			
			
			//myIP = "192.168.0.187";
			myIP = "chatpetz.com";
			
			
			//smartFox.connect(myIP);
			//loginPanel.bt_login.enabled = false;
			//loginPanel.ti_username.enabled = false;
			avatarManager = new AvatarManager(this, openSpace);
			
			
			
			avatarManager.loadAvatarsLibrary()
			//MCPlayer.play(new LoginScreen() as MovieClip);
			
			
			SoundManager.setMainChatpet("PIFF")
			
			
			loginScreen = new LoginScreen(this,container.spLoginContainer);
			loginScreen.open();
			
			
		}
		
		public function login(user:String,pwd:String) : void {
			myUsername = user;
			smartFox.connect(myIP);
		}
		
		
		
		//-------------------------------------------------------
		// 1. Handle SmartFoxServer connection & login
		//-------------------------------------------------------
		
		/**
		 * On successfull connection, login is attempted.
		 */
		private function onSFSConnection(evt:SFSEvent):void
		{
			if (evt.params.success)
			{
				logTrace("Connection successful, now performing login");
				smartFox.login(smartFox.defaultZone, myUsername, "");
				loginScreen.close();
			}
			else
			{
				loginScreen.open();
				//loginPanel.bt_login.enabled = true;
				//loginPanel.ti_username.enabled = true;
				logTrace("Can't connect to " + smartFox.ipAddress + ":" + smartFox.port);
			}
		}
		
		/**
		 * Connection lost event handler.
		 */
		private function onSFSConnectionLost(evt:SFSEvent):void
		{
			logTrace("Connection lost");
			loginScreen.open();
			//loginPanel.bt_login.enabled = true;
			//loginPanel.ti_username.enabled = true;
			//loginPanel.ti_username.setFocus();
			//bt_reload.enabled = false;
			//bt_reset.enabled = false;
			
			// Map & edit controls are reset in the OpenSpaceEvent.RESET event handler
		}
		
		/**
		 * Login event handler.
		 * On successfull login, nothing happens because we have to wait for the roomlist to be available.
		 */
		private function onSFSLogin(evt:SFSEvent):void
		{
			if (evt.params.success)
			{
				myUsername = evt.params.name;
				//loginPanel.ti_username.text = evt.params.name;
				logTrace("Successfully logged in as " + myUsername);
				
				
			}
			else
			{
				
				logTrace("Login error: " + evt.params.error);
				
				smartFox.disconnect();
			}
		}
		
		/**
		 * On room list received, OpenSpace is initialized.
		 */
		private function onSFSRoomListUpdate(evt:SFSEvent):void
		{
			logTrace("Roomlist received, now a map can be loaded");
			
			//bt_reload.enabled = true;
			//bt_reset.enabled = true;
			// Initialize OpenSpace
			if (!bInitialized) {
				bInitialized = true;
				initializeOpenSpace();
			}
			else
				loadMap("Home");
			
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
			
			openSpace.init(smartFox); //, null);
			
			worldUI.open();
			
			
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
			// Load map
			currentMap = sfsRoomToJoin;
			
			switch (currentMap) {
				case "Moon":
					
					break;
				case "Africa":
					
					
					SoundManager.playBeep(ChatpetzCodes.WORLD_CLICK_AFRICA);
					break;
			}
			
			openSpace.loadMap(sfsRoomToJoin);
		}
		
		public function unloadMap():void
		{
			// Unload map
			
			openSpace.unloadMap();
		}
		
		public function getBack() : void {
			SoundManager.setLibrary("WorldSounds");
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
		private function onOpenSpaceInitialized(evt:OpenSpaceEvent):void
		{
			logTrace("OpenSpace.INITIALIZED event received");
			loadMap("Home");
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
			SoundManager.stopAllSounds();
			logTrace("OpenSpace.MAP_RENDERED event received");
			openSpace.mapScrollingEnabled = false;
			//if (viewStack.selectedChild!=openSpaceCanvas)
			//	viewStack.selectedChild = openSpaceCanvas;
			
			
			
			
			//var mc:MovieClip = openSpace.getSkinByName("caveTile", "caveSkin") as MovieClip;
			//if (mc)
			//	mc.gotoAndPlay(1);
			
			switch (currentMap) {
				case "Home":
					SoundManager.playBeep(ChatpetzCodes.WORLD_ENTER_ROOM);
					break;
				case "Moon":
					SoundManager.playBeep(ChatpetzCodes.WORLD_CLICK_MOON);
					break;
				case "Africa":
					
					SoundManager.playMusic(WorldSounds.AFRICA_MUSIC);
					break;
			}
			
			
		}
		
		
		private function playGame(game:String) : void {
			worldUI.close();
			gameManager.load(game);
			unloadMap();
		}
		
		private function playMovie(movie:String) : void {
			container.spMCContainer.addChild(new MoviePlayer(movie,this));
		}

		public function exit(obj:Object) : void {
			container.spMCContainer.removeChild(obj as DisplayObject);
			if (obj is MoviePlayer) {
				
				switch ((obj as MoviePlayer).getMovieName()) {
					case "MoonToEarthMC" :
					case "EarthToMoonMC" :
						container.spMCContainer.addChild(new EarthMap(this));
						
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
				
			} else if (obj is Freezer) {
				
			}
		}
		
		
		private function getMovieClipOnBackground(name:String) : MovieClip {
			var arr:Array = openSpace.getBackgroundParts().toArray();
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
					unloadMap();
					
				} else if (trigger.target == "earthSpaceShip") // Change map
				{
					playMovie("EarthToMoonMC")
					unloadMap();
					
				} else if (trigger.target == "home") // Change map
				{
					loadMap("Home");
				} else if (trigger.target == "door") // Change map
				{
					loadMap("Moon");
				} else if (trigger.target == "safari") // Change map
				{
					playGame("games/Safari.swf");
					
				} else if (trigger.target == "speed") // Change map
				{
					playGame("games/Speed.swf");
				} else if (trigger.target == "shop") // Change map
				{
					playGame("games/ChatpetzClouds.swf");
				} else if (trigger.target == "cave") 
				{
					playGame("games/ChatpetzTrivia.swf");
				} else if (trigger.target == "freezer") // Change map
				{
					container.spMCContainer.addChild(new Freezer(this));
					//var mc:MovieClip = openSpace.getSkinByName("feedmeTile", "feedmeSkin") as MovieClip;
					
					//mc.gotoAndPlay("open");
					
					//mc.mouseEnabled = true;
					//mc.mouseChildren = true;
				} else if (trigger.target == "board") // Change map
				{ 
					container.spMCContainer.addChild(new Achievements(this));
				}
				else if (trigger.target == "giraffe") 
				{
					SoundManager.playBeep(ChatpetzCodes.AFRICA_CLICK_GIRAFFE)
					
				} else if (trigger.target == "tiger") 
				{
					SoundManager.playBeep(ChatpetzCodes.AFRICA_CLICK_TIGER)
				} else if (trigger.target == "termites") 
				{
					SoundManager.playBeep(ChatpetzCodes.AFRICA_CLICK_TERMITES)
				} else if (trigger.target == "bug") 
				{
					SoundManager.playBeep(ChatpetzCodes.AFRICA_CLICK_BUG)
				}
			
			} else if (evt.type == MapInteractionEvent.SKIN_ROLL_OVER)
			{
			
				if (skinsNames.indexOf(trigger.target)!=-1) {
					var mc1:MovieClip = getMovieClipOnBackground(trigger.target);
					//if (!mc1)
					//mc1 = skin as MovieClip;
					mc1.gotoAndPlay("over"); 
				}
				
			}
			else if (evt.type == MapInteractionEvent.SKIN_ROLL_OUT)
			{
				if (skinsNames.indexOf(trigger.target)!=-1) 
					(getMovieClipOnBackground(trigger.target) as MovieClip).gotoAndPlay("out");		
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
		}
		
		public function logTrace(txt:String):void
		{
			debugPanel.logTrace(txt); 
		}	
		
		
		
		 // ================ AVATAR CONTROLS ================
		public function onAvatarDown(chatpet:String) : void {
			avatarManager.changePlayerAvatarSkin(chatpet);
			SoundManager.setMainChatpet(chatpet);
			//ChatpetzBeeps.chooseAndPlay(new Array(ChatpetzCodes.WORLD_SWITCH_CHATPET,ChatpetzCodes.WORLD_USE_CHATPET));
		}

		public function sendMessage(msg:String) : void {
			smartFox.sendPublicMessage(msg);
		}
		
		
		
		
	}
}
