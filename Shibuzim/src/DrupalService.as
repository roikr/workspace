package {
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.crypto.hash.SHA256;
	import com.hurlant.util.Hex;

	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.utils.ByteArray;

	// Import all dependencies


	// Declare our DrupalService class.
	public class DrupalService extends NetConnection {
		// The DrupalService constructor.
		public function DrupalService( _gateway:String, _api:String ) {
			// Save the gateway path and apiKey.
			gateway=_gateway;
			apiKey=_api;

			// Set the object encoding and connect to Drupal.
			objectEncoding=flash.net.ObjectEncoding.AMF3;
			super.connect(gateway);
		}

		// Connect to our Drupal system.
		public function connectToDrupal( _onConnected:Function ) {
			// Set our callback function.
			onConnected=_onConnected;

			// Call our system.connect service.
			serviceCall( "system.connect", onConnect, null );
		}

		// Create a service Call method.
		public function serviceCall(command:String, onSuccess:Function, onFailed:Function, ... args) {
			// Use default error handler if none is provided.
			if (onFailed==null) {
				onFailed=onError;
			}

			// Declare our responder.
			var responder:Responder=new Responder(onSuccess,onFailed);

			// Setup our arguments.
			setupArgs( command, args );

			// Switch and make the call.
			switch ( args.length ) {
				case 0 :
					call( command, responder );
					break;
				case 1 :
					call( command, responder, args[0] );
					break;
				case 2 :
					call( command, responder, args[0], 
					  args[1] );
					break;
				case 3 :
					call( command, responder, args[0], 
					  args[1], 
					  args[2] );
					break;
				case 4 :
					call( command, responder, args[0], 
					  args[1], 
					  args[2], 
					  args[3] );
					break;
				case 5 :
					call( command, responder, args[0], 
					  args[1], 
					  args[2], 
					  args[3], 
					  args[4] );
					break;
				case 6 :
					call( command, responder, args[0], 
					  args[1], 
					  args[2], 
					  args[3], 
					  args[4], 
					  args[5] );
					break;
				case 7 :
					call( command, responder, args[0], 
					  args[1], 
					  args[2], 
					  args[3], 
					  args[4], 
					  args[5],
					  args[6] );
					break;
				default :
					trace("Too many arguments in DrupalService");
					break;
			}
		}

		// Setup the arguments.
		private function setupArgs( command:String, args:Object ) {
			// Add the session Id as the first argument.
			args.unshift( sessionId );

			// Check to see if we should add the API key.
			if (usesKey(command)) {

				var baseURL:String=getBaseURL();
				var timestamp:String=getTimeStamp();
				var nonce:String=getNonce();
				var hash:String=getHash(timestamp,baseURL,nonce,command);

				args.unshift( nonce );
				args.unshift( timestamp );
				args.unshift( baseURL );
				args.unshift( hash );
			}
		}

		// Get the baseURL.
		private function getBaseURL():String {
			// The regular expression to find "http://"
			var http:RegExp=/^(http[s]?\:[\\\/][\\\/])/;

			// Remove the "http://" from the gateway.
			var baseURL:String=gateway.replace(http,"");

			// Remove "/services/amfphp" from the gateway.
			baseURL=baseURL.replace("/services/amfphp","");

			// Return the base URL.
			return baseURL;
		}

		// Get the timestamp.
		private function getTimeStamp():String {
			// Get the current date/time
			var now:Date = new Date();

			// Get the time as a timestamp.
			var nowTime:Number=Math.floor((now.getTime() / 1000));

			// Return it as a string.
			return int(nowTime).toString();
		}

		// Returns the nonce, or 10 character random string.
		private function getNonce():String {
			// Create an alphabet string with all the alphabet.
			var alphabet:String="abcdefghijkmnopqrstuvwxyz";
			alphabet+="ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

			// Store the length.
			var len:int=alphabet.length-1;
			var randString:String='';

			// Iterate 10 times for each character.
			for (var i:int = 0; i < 10; i++) {
				// Append a random character.
				randString+=alphabet.charAt(rand(len));
			}

			// Return our random string.
			return randString;
		}

		// Generate a random number with a max range.
		private static function rand(max:Number):Number {
			return Math.round(Math.random() * (max - 1));
		}

		// Get the hash of all values.
		private function getHash( timestamp:String, domain:String, nonce:String, method:String ):String {
			// Combine all values into an input string.
			var input:String=timestamp+";";
			input+=domain+";";
			input+=nonce+";";
			input+=method;

			// Create an SHA256 encoded HMAC object.
			var hmac:HMAC = new HMAC( new SHA256() );

			// Convert the API Key into a ByteArray.
			var kdata:ByteArray=Hex.toArray(Hex.fromString(apiKey));

			// Convert our input string into a ByteArray.
			var data:ByteArray=Hex.toArray(Hex.fromString(input));

			// Compute our hash.
			var currentResult:ByteArray=hmac.compute(kdata,data);

			// Return our hash in string form.
			return Hex.fromArray(currentResult);
		}

		// Determines if we should use an API Key.
		private function usesKey( command:String ):Boolean {
			switch ( command ) {
				case "user.login" :
				case "user.logout" :
				case "node.save" :
					return true;
					break;
			}

			return false;
		}

		// Called when we have connected to Drupal
		private function onConnect( result:Object ) {
			// Set our session Id and user object.
			sessionId=result.sessid;
			user=result.user;

			// Call the callback function.
			onConnected( {user:user, sessid:sessionId} );
		}

		// Called when an error occurs connecting to Drupal.
		private function onError( error:Object ) {
			trace("An error has occurred!");
		}

		// Store our user and session Id.
		public var user:Object;
		public var sessionId:String="";
		public var gateway:String="";
		public var apiKey:String="";

		// Set the onConnected callback function.
		private var onConnected:Function;
	}
}