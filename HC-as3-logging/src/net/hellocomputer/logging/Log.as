package net.hellocomputer.logging 
{
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.events.UncaughtErrorEvent;
	import flash.system.Capabilities;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.ILogSetup;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.as3commons.logging.simple.debug;
	import org.as3commons.logging.util.locationFromStackTrace;
	/**
	 * ...
	 * @author Peter Cardwell-Gardner
	 */
	public class Log 
	{
		protected static var _smartLogging:Boolean = false;
		
		public function Log() 
		{
			
		}
		
		/**
		 * This is a neater wrapper for as3commons logging initialisation setup. Also allows to init a few extra params
		 * @param	logSetup As3 commons log setup, refer to as3 commons documentation. 
		 * You can do a whole bunch of useful stuff with these. 
		 * Like merging targets, having targets that only log certain levels of event, 
		 * targets that only fire when a certain log level is reached.s
		 * @param	
		 */
		public static function set setup(logSetup:ILogSetup):void
		{
			LOGGER_FACTORY.setup = logSetup;
		}
		
		public static function smartLog(message:*, params:Array = null, level:int = 0x0020, name:String=null):void
		{
			var logger:ILogger;
			
			if (_smartLogging && Capabilities.isDebugger)
			{
				var err:Error = new Error();
				var stackTrace:Array = err.getStackTrace().split("\n");
				var src:String = stackTrace[3];
				var className:String = src.slice(4, src.indexOf("()"));
				var packageIndex:int = className.indexOf("::");
				if(packageIndex > -1) className = className.slice(className.indexOf("::") + 2);
				//Can't pass line numbers to as3 commons without rewriting it or killing deep inspection of Arrays/Objects etc. Leaving it out for now
				//var lineNum:String = src.slice(src.lastIndexOf(":")+1, src.lastIndexOf("]"));
				//if (message is String) message = lineNum +" - " + message;
				logger = getLogger(className, name);
				
			}
			else
			{
				logger = getLogger("default", name);
			}
			
			switch (level) 
			{
				case LogLevel.DEBUG:
					logger.debug(message, params);
				break;
				case LogLevel.INFO:
					logger.info(message, params);
				break;
				case LogLevel.WARN:
					logger.warn(message, params);
				break;
				case LogLevel.ERROR:
					logger.error(message, params);
				break;
				case LogLevel.FATAL:
					logger.fatal(message, params);
				break;
				default:
					logger.debug(message, params);
					break;
			}
		}
		
		/**
		 * smartLogging This will attempt find the source of the log statement using a stack trace. 
		 * This can incur quite a performance penalty, and cause errors with release builds/non debug players so is left as an optional parameter.
		 */
		static public function get smartLogging():Boolean 
		{
			return _smartLogging;
		}
		
		/**
		 * @private
		 */
		static public function set smartLogging(value:Boolean):void 
		{
			_smartLogging = value;
		}
		
		/**
		 * Based directly off the the as3Loggins version, which is still available. The difference is that I don't want to kill error windows, 
		 * as minimizes coverage and chances that a bug will get caught. 
		 * @param	loaderInfo this should Ideally be the loader info the root
		 */
		static public function captureUncaughtEvents(loaderInfo:LoaderInfo):void
		{
			if( loaderInfo.hasOwnProperty("uncaughtErrorEvents") ) {
				var events: EventDispatcher = loaderInfo["uncaughtErrorEvents"];
				events.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtError, false, 0, true );
			}
		}
		
		private static function handleUncaughtError(e:UncaughtErrorEvent):void 
		{
			var logger:ILogger = getLogger("UncaughtError");
			logger.fatal( e["error"] );
		}
		
		
		
	}

}