package {
	/**
	 * @author roikr
	 */
	public class AvatarTrigger {
		private var beepNum:int;
		
		private static var lastChatpet:String = "";
		private static var nextGroup:int = 0;
		private static var nextStage:int = 0;
		
		
		private var xml:XML = <triggers>
	<double>
		<group>
			<sentences>
				<sentence number="100"/>
				<sentence number="101"/>
				<sentence number="102"/>
			</sentences>
			<beeps>
				<beep number="1"/>
				<beep number="2"/>
				<beep number="13"/>
				<beep number="14"/>
			</beeps>
		</group>
		<group>
			<sentences>
				<sentence number="120"/>
				<sentence number="121"/>
				<sentence number="122"/>
				<sentence number="123"/>
			</sentences>
			<beeps>
				<beep number="1"/>
				<beep number="2"/>
				<beep number="5"/>
				<beep number="12"/>
				<beep number="15"/>
			</beeps>
		</group>
	</double>
	
	<one>
		<group>
			<stage>
				<sentence number="500"/>
			</stage>
			<stage>
				<sentence number="510"/>
			</stage>
			<stage>
				<sentence number="520"/>
				<sentence number="521"/>
				<sentence number="522"/>
			</stage>
			<stage>
				<sentence number="530"/>
				<sentence number="531"/>
			</stage>
			<stage>
				<sentence number="540"/>
				<sentence number="541"/>
				<sentence number="542"/>
			</stage>
		</group>
		
		<group>
			<stage>
				<sentence number="550"/>
			</stage>
			<stage>
				<sentence number="560"/>
			</stage>
			<stage>
				<sentence number="570"/>
				<sentence number="571"/>
				<sentence number="572"/>
			</stage>
			<stage>
				<sentence number="580"/>
				<sentence number="581"/>
				<sentence number="582"/>
			</stage>
			<stage>
				<sentence number="590"/>
			</stage>
		</group>
		
		<group>
			<stage>
				<sentence number="600"/>
			</stage>
			<stage>
				<sentence number="610"/>
			</stage>
			<stage>
				<sentence number="620"/>
				<sentence number="621"/>
				<sentence number="622"/>
			</stage>
			<stage>
				<sentence number="630"/>
			</stage>
		</group>
	</one>
	
	<chatpetz>
		<chatpet name="PIFF" path="200_piff"/>
		<chatpet name="PARPARA" path="201_pink"/>
		<chatpet name="POPO" path="202_orange"/>
		<chatpet name="POGGY" path="203_blue"/>
	</chatpetz>
</triggers>;
		
		
		
		public function AvatarTrigger(chatpet:String,bMine:Boolean,bDoubleClick:Boolean,lastSentence:int = 0) : void {
			
			var host:String = "http://chatpetz.com/";
			
			trace(chatpet + " " + (bDoubleClick ? "double" : "single") + " click, mine:" + bMine);
			
			if (bDoubleClick) {
				var groups:XMLList = xml.double.group;
				trace("groups: "+groups.length());
				var group:XML = groups[int(Math.random()*groups.length())] 
				var sentences :XMLList = group.sentences.sentence;
				trace("sentences: "+sentences.length());
				var sentence:XML = sentences[int(Math.random()*sentences.length())]
				trace("sentence: "+sentence.@number)
				
				var chatpetXML:XML = xml.chatpetz.chatpet.(@name==chatpet)[0];
				trace("chatpet: "+chatpetXML.@name+" ,path: "+chatpetXML.@path)
				var url:String = host+"mp3/" + chatpetXML.@path + "/Double/" + sentence.@number.toString()+".mp3";
				trace("url: "+url)
				new RKSound(url,this,true,false);
				
				var beeps :XMLList = group.beeps.beep;
				trace("beeps: "+beeps.length());
				var beep:XML = beeps[int(Math.random()*beeps.length())]
				trace("beep: "+beep.@number)
				beepNum = beep.@number;
			} else {
				
				
			}
			
			/*
			trace(chatpet + " " + (bDoubleClick ? "double" : "single") + " click, mine:" + bMine);
			var _code : int = bDoubleClick ? 0 : Math.random()*187;
			
			if (bDoubleClick) {
				new RKSound(host+"voice_4_web/" + chatpet + "/" + chatpet+_code.toString()+".mp3",this,true,false);
			} else {
				new RKSound(host+"mp3/" + chatpet + "/" + chatpet+_code.toString()+".mp3",null,true,false);
			}*/
			
		}
		
		public function onSoundComplete( sound:RKSound) : void {
			trace("playing beep "+beepNum );		
			new Beep(beepNum,this);
		}
		
		public function onBeepCompleted(obj:Object) : void {
			trace("done")
		}
	}
}
