package {

	/**
	 * @author roikr
	 */
	public interface IGameManager {
		function load(url:String) : void;
		function unload() : void ;
		function close() : void;
		
		// calls from game to manager
		function setScore(score:int) : void;
		function setLevel(level:int) : void;
		function setTime(time:int) : void;
		function setStars(stars:Number) : void;
		function playChatpetzCode(code:int,probability:Number=1.0) : int;
		function chooseAndPlayChatpetzCode(arr:Array,probability:Number=1.0) : int;
	}
}
