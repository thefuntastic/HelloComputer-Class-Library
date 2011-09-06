package net.hellocomputer.logging 
{
	/**
	 * This simply provide a nicer implementation of the as3 commons log library that autocompletes nicely
	 * @author Peter Cardwell-Gardner
	 */
	public class LogLevel
	{
		
		public static const DEBUG:int = 0x0020;
		public static const INFO:int  = 0x0010;
		public static const WARN:int  = 0x0008;
		public static const ERROR:int = 0x0004;
		public static const FATAL:int = 0x0002;
	}

}