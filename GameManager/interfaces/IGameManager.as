package {
	import flash.display.MovieClip;

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
		function setStars(stars:int) : void;
		function getAvatar() : MovieClip;
	}
}
