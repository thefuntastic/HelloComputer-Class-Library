package 
{
	import net.hellocomputer.logging.Log;
	
	/**
	 * Top level function that provides access to the logging package without the need to import anything!
	 * This function is much like php in that it provides string subsitution making formating trace statements easier.
	 * @param	message The string or object to be logged
	 * @param	params an array of params to be substituted into the string message. 
	 * "The instance {0}, has {1} children", [this.name, this.numChildren] 
	 * //The instance _mcContainer has 5 children
	 * @param	level See LogLevel for valid types, defaults to DEBUG
	 */
	public function printf(message:*, params:Array = null, level:int=0x0020):void
	{
		Log.smartLog(message, params, level);
		
	}

}