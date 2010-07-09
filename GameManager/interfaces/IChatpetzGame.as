package {

	/**
	 * @author roikr
	 */
	public interface IChatpetzGame {
		function start(manager:IGameManager) : void;
		function pause() : void;
		function help() : void;
		function exit() : void;
	}
}
