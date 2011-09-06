package  
{
	import net.hellocomputer.logging.Log;
	
	/**
	 * This is exactly the same as printf, but creates a logger using the name of the person who created it. 
	 * This makes it much easier to filter results when working in a team
	 * @param	name Name of the person who wrote the log statement. 
	 * @param	message 
	 * @param	params
	 * @param	level
	 * @see log
	 */
	public function printfNamed(name:String, message:*, params:Array = null, level:int = 0x0020):void
	{
		Log.smartLog(message, params, level, name);
	}


}