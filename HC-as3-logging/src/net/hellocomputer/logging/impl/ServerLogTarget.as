package net.hellocomputer.logging.impl 
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import net.hellocomputer.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.target.IFormattingLogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	
	/**
	 * ...
	 * @author Peter Cardwell-Gardner
	 */
	public class ServerLogTarget implements IFormattingLogTarget 
	{
		public static var DEFAULT_FORMAT:String = "{logLevel} - {shortName}{atPerson} - {message}";
		private var _formatter:LogMessageFormatter;
		
		private var _url:String;
		protected var _buffer:Array;
		
		public function ServerLogTarget(url:String, bufferSize:int = 50, format:String = null) 
		{
			_url = url;
			_buffer = [];		
			this.format = format;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set format(format:String):void {
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
		}
		
		/* INTERFACE org.as3commons.logging.setup.ILogTarget */
		
		public function log(name:String, shortName:String, level:int, timeStamp:Number, message:*, parameters:Array, person:String):void 
		{
			_buffer.push(_formatter.format(name, shortName, level, timeStamp, message, parameters, person));
			if (level == LogLevel.FATAL)
			{
				sendReport();
			}
		}
		
		private function sendReport():void 
		{
			var data:String = _buffer.join("\n\t");
			_buffer = [];
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(_url);
			var urlVars:URLVariables = new URLVariables();
			urlVars.data = data;
			urlRequest.data = urlVars;
			urlRequest.method = URLRequestMethod.POST;
			urlLoader.load(urlRequest);
			trace(data);
			
		}
		
	}

}