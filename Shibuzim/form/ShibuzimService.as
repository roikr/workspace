package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author roikr
	 */
	public class ShibuzimService extends Sprite {
		
		private var form:Form;
		
		private var baseURL:String="http://www.shibuzim.co.il";
		private var gateway:String=baseURL+"/services/amfphp";
		private var nodeId:Number;
		private var apiKey:String="44085907f16bdf716ad888b9d527e9e0";
		
		private var user:Object=null;
		private var currentNode:Object=null;
		
		private var drupal:DrupalService;
		
		private var _code:String;
		private var _list:String;
		
		private var _client:Object;
		
		
		public function ShibuzimService(_client:Object,nid:Number = 0) {
			
			
			
			form=new Form();
			form.submit.addEventListener( MouseEvent.CLICK, onNodeSubmit );
			form.cancel.addEventListener(MouseEvent.CLICK,function () {hide();})
			

			drupal=new DrupalService(gateway,apiKey);

			this._client = _client;
			nodeId = nid;
			drupal.connectToDrupal( onConnect );

		}
		
//		public function set client() : void {
//			this._client = _client;
//		}
		
		
		
		
		
		public function show() : void {
			form.xml.text = _code;
			form.list.text = _list;
			addChild(form);
		}
		
		public function set code(_code:String) : void {
			this._code = _code;
		}
		
		public function get code() : String {
			return _code;
		}
		
		public function set list(_list:String) : void {
			this._list = _list;
		}
		
		private function hide() : void {
			removeChild(form);
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
				log="";
			}
		}
		
		function loadNode( nid:Number ) {
			drupal.serviceCall( "node.get", onNodeLoad, null, nid );
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
			form.title.text=node.title;
			form.desc.text=node.field_artwork_desc[0]["value"];
			form.author.text=node.field_artwork_author[0]["value"];
			form.email.text=node.field_author_email[0]["value"];
			form.order.selected=node.field_order_now[0]["value"] == "yes";
			form.phone1.text=node.field_author_phone1[0]["value"];
			form.phone2.text=node.field_author_phone2[0]["value"];
			form.address.text=node.field_author_address[0]["value"];
			form.city.text=node.field_author_city[0]["value"];
			form.zip.text=node.field_author_zip[0]["value"];
			form.country.text=node.field_author_country[0]["value"];
			_code = form.xml.text=node.field_xml_code[0]["value"];
			_list = form.list.text = node.field_parts_list[0]["value"];
			
		
		   // Roee - I wanted to logout the flash-shi user, but there is a problem.
		   //        commenting out for now and will solve later. Dubi
			//if (user&&user.name=='flash-shi') {
			//  drupal.serviceCall( "user.logout", setUser, onUserError );
			//}	
			_client.onClient(this);
		}
		
		
		function onNodeSubmit( event:MouseEvent ) {
			
			_code = form.xml.text;
			_list = form.list.text;
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
			//hide();
			
		}
		
		function setUserSaveNode( result:Object ) {
			setUser( result );
			saveNode();
		}
		
		function saveNode() {
			// Roee - here the node gets saved with the data in the
			//        form fields as well as the XML of the simulator
		
			// adding "FW:" to title just in order to see change during API testing
			var titleText:String="FW: "+form.title.text;
		
			
			// field_order_now gets either "no" or "yes"
			// "no"  :  means save only
			// "yes" :  means save and order
			//var order_nowText=field_order_now.text;
		
			
			
		
			// Roee - I am not sure if the following chars cleaning is needed here
			//        but for real text input fields(name,email,phone,etc.)
			//        it won't harm, so I added an example here. Dubi
			titleText=titleText.replace(/[\t\n\r\f]/,'');
		
			// Roee - here, you need to check all mandatory input fields
			//        the following "if" is an example for titleText only.
			if (titleText.length) {
				var newNode:Object=new Object  ;
		
				// Roee - here you need to set condition for when to update (rather than create).
				//        when updating the cuurent node, must use the same ID,
				//        otherwise, a new node will be created.
				// the condition here is fake (always true), hence only update takes place
				if (form.update.selected) {
					newNode.nid=currentNode.nid;
				}
		
				newNode.type="tiles_artwork";
		
				newNode.title=form.desc.text;
		
				newNode.field_artwork_desc=new Array({value:form.desc.text});
		
				newNode.field_artwork_author=new Array({value:form.author.text});
		
				newNode.field_author_email=new Array({value:form.email.text});

				newNode.field_order_now = new Array({value:form.order.selected ? "yes" : "no"});
		
				newNode.field_author_phone1=new Array({value:form.phone1.text});
		
				newNode.field_author_phone2=new Array({value:form.phone2.text});
		
				newNode.field_author_address=new Array({value:form.address.text});
		
				newNode.field_author_city=new Array({value:form.city.text});
		
				newNode.field_author_zip=new Array({value:form.zip.text});
		
				newNode.field_author_country=new Array({value:form.country.text});
		
				newNode.field_xml_code=new Array({value:_code});
				
				newNode.field_parts_list = new Array({value:_list});
					
				
				drupal.serviceCall("node.save", onNodeCreate, onNodeError, newNode);
			} else {
				// Roee - here, you may want to tell the user about mandatory fields
				//        either by using the status line or any other visual method
				log="title is mandatory";
			}
		}
		
		
		
		
		
		
		
		function onNodeCreate( nodeId:Number ) {
			hide();
			log = "node created"
			//drupal.serviceCall( "node.get", onNodeLoad, null, nodeId );
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
			
			form.log.text+=str+'\n';
			_client.log=str;
		}
	}
}
