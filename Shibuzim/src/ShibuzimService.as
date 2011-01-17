package {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author roikr
	 */
	public class ShibuzimService extends Sprite {
		
		private var form:Form;
		private var message:Message;
		private var order:Boolean;
		
		private var baseURL:String="http://www.shibuzim.co.il";
		private var gateway:String=baseURL+"/services/amfphp";
		private var nodeId:Number;
		private var apiKey:String="44085907f16bdf716ad888b9d527e9e0";
		
		private var user:Object=null;
		private var currentNode:Object=null;
		
		private var drupal:DrupalService;
		
		private var _code:String;
		private var _partsList:String;
		private var _tilesOrder:String
		
		private var _client:Object;
		
		
		public function ShibuzimService(_client:Object,nid:Number = 0) {
			
			
			
			form=new Form();
			message = new Message();
			form.save.addEventListener( MouseEvent.CLICK, onNodeSubmit );
			form.send.addEventListener( MouseEvent.CLICK, onNodeSubmit );
			form.cancel.addEventListener(MouseEvent.CLICK,function () : void {removeChild(form);})
			
			message.shibuzim.addEventListener(MouseEvent.CLICK,function () : void {removeChild(message);;})
			message.home.addEventListener(MouseEvent.CLICK,function () : void {navigateToURL(new URLRequest(baseURL),"_self");;})
			

			drupal=new DrupalService(gateway,apiKey);

			this._client = _client;
			nodeId = nid;
			drupal.connectToDrupal( onConnect );

		}
		
//		public function set client() : void {
//			this._client = _client;
//		}
		
		
		
		
		
		public function show() : void {
			
			addChild(form);
			form.mcMust.visible = false;
		}
		
		public function set code(_code:String) : void {
			
			this._code = _code;
		}
		
		public function get code() : String {
			return _code;
		}
		
		public function set partsList(_partsList:String) : void {
			this._partsList = _partsList;
		}
		
		public function set tilesOrder(_tilesOrder:String) : void {
		
			this._tilesOrder = _tilesOrder;
		}
		
		
		
		function onConnect( result:Object ) {
			log="connected";
			setUser( result );
			
			if (nodeId) {
				loadNode( nodeId );
			}
		}
		
		function setUser( result:Object ) {
			if (result is Boolean) {
				user.userid=0;
			} else {
				drupal.sessionId=result.sessid;
				user=result.user;
				log="logged in as: "+user.name;
				log="Session Id: "+drupal.sessionId;
			}
			if (user&&user.userid>0) {
				//clearing status
				//log="";
			}
		}
		
		function loadNode( nid:Number ) {
			drupal.serviceCall( "node.get", onNodeLoad, null, nid );
		}
		
		function value(obj:Object) : String {
			return obj[0]["value"] ? String(obj[0]["value"]) : ""
		}
		
		function onNodeLoad( node:Object ) {

			currentNode=node;
		
			// Roee - the following are flash elements to be used
			//        in the later in the form.
			//        note that "title" is a drupal mandatory for the node.
			//        We can use it to sort out the saved nodes.
			//        We can use it as a code like yyyy-mm-dd--????
			//        It doesn't have to be unique, but it should help
			//        finding out what is what.
			log="title: " + node.title;
			//log="desc: " + value(node.field_artwork_desc);
			
			form.code.text=value(node.field_personal_code);
			form.email.text=value(node.field_author_email);
			log="order: "+ value(node.field_order_now);
			form.phone1.text=value(node.field_author_phone1);
			form.phone2.text=value(node.field_author_phone2);
			form.address.text=value(node.field_author_address);
			form.city.text=value(node.field_author_city);
			form.zip.text=value(node.field_author_zip);
			form.country.text=value(node.field_author_country);
			//log = value(node.field_xml_code);
			//log = value(node.field_parts_list);
			
			_code = value(node.field_xml_code);
		   // Roee - I wanted to logout the flash-shi user, but there is a problem.
		   //        commenting out for now and will solve later. Dubi
			//if (user&&user.name=='flash-shi') {
			//  drupal.serviceCall( "user.logout", setUser, onUserError );
			//}	
			_client.onClient(this);
		}
		
		
		function onNodeSubmit( event:MouseEvent ) {
			
			order = event.target == form.send;
			
			if (form.code.text.length  && form.city.length && form.country.text.length 
					&& ((form.phone1.text.length  && form.email.text.length) || !order)    ) {
			
				
				
				log = "onNodeSubmit"
				log = "with user: "+user.userid;
				
				if (user&&user.userid==0) {
					log = user.userid;
					var username:String='flash-shi';
					var password:String='L3tMi0rder!';
					drupal.serviceCall( "user.login", setUserSaveNode, onUserError, username, password );
				} else {
					saveNode();
				}
			}  else {
				// Roee - here, you may want to tell the user about mandatory fields
				//        either by using the status line or any other visual method
				log="mandatory field";
				form.mcMust.visible = true;
			}
			
			
		}
		
		function setUserSaveNode( result:Object ) {
			setUser( result );
			saveNode();
		}
		
		
	
		public static function cleanText(str:String) : String {
			// Roee - I am not sure if the following chars cleaning is needed here
			//        but for real text input fields(name,email,phone,etc.)
			//        it won't harm, so I added an example here. Dubi
			return str.replace(/[\t\n\r\f]/,'');
		}
		
		
		
		function saveNode() {
			
			// field_order_now gets either "no" or "yes"
			// "no"  :  means save only
			// "yes" :  means save and order
			//var order_nowText=field_order_now.text;
		
			
			var newNode:Object=new Object  ;
	
			newNode.type="tiles_artwork";
	
			newNode.title="title - "+form.code.text;
			
			log = cleanText(form.code.text);
	
			//newNode.field_artwork_desc=new Array({value:cleanText(form.author.text)});
	
			//newNode.field_artwork_author=new Array({value:cleanText(form.author.text)});
			
			newNode.field_personal_code = new Array({value:cleanText(form.code.text)});
	
			newNode.field_author_email=new Array({value:cleanText(form.email.text)});

			newNode.field_order_now = new Array({value:order ? "yes" : "no"});
	
			newNode.field_author_phone1=new Array({value:cleanText(form.phone1.text)});
	
			newNode.field_author_phone2=new Array({value:cleanText(form.phone2.text)});
	
			newNode.field_author_address=new Array({value:cleanText(form.address.text)});
	
			newNode.field_author_city=new Array({value:cleanText(form.city.text)});
	
			newNode.field_author_zip=new Array({value:cleanText(form.zip.text)});
	
			newNode.field_author_country=new Array({value:cleanText(form.country.text)});
	
			newNode.field_xml_code=new Array({value:_code});
			
			newNode.field_parts_list = new Array({value:_partsList});
			newNode.field_tiles_order = new Array({value:_tilesOrder});
			
				
			
			drupal.serviceCall("node.save", onNodeCreate, onNodeError, newNode);
		
		}
		
		
		
		
		
		
		
		function onNodeCreate( nodeId:Number ) {
			
			log = "node created: " + nodeId.toString();
			//drupal.serviceCall( "node.get", onNodeLoad, null, nodeId );
			removeChild(form);
			message.mcSave.visible = !order;
			message.mcSend.visible = order;
			addChild(message);
		}
		
		function onError( error:Object ) {
			for each (var item in error) {
				log="onError: "+item;
			}
		}
		
		function onUserError( error:Object ) {
			log="onUserError: "+error.description;
		}
		
		function onNodeError( error:Object ) {
			log="onNodeError: "+error.faultString;
		}
		
		
		function set log(str:String) {
			
			_client.log=str;
		}
	}
}
