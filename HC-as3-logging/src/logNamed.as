package  
{
	import net.hellocomputer.logging.Log;
	
	/**
	 * This is exactly the same as log, but creates a logger using the name of the person who created it. 
	 * This makes it much easier to filter results when working in a team
	 * @param	name Name of the person who wrote the log statement. 
	 * @param	message 
	 * @param	level
	 * @see log
	 */
	public function logNamed(name:String, message:*, level:int = 0x0020):void
	{
		Log.smartLog(message, null, level, name);
	}


}