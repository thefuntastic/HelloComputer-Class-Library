package net.hellocomputer.logging.impl 
{
	import flash.display.Stage;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import net.hellocomputer.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.setup.target.IFormattingLogTarget;
	import org.as3commons.logging.util.here;
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.as3commons.logging.util.logRuntimeInfo;
	
	/**
	 * ...
	 * @author Peter Cardwell-Gardner
	 */
	public class ServerLogTarget implements IFormattingLogTarget 
	{
		public static var DEFAULT_FORMAT:String = "{time} {logLevel} - {shortName}{atPerson} - {message}";
		protected var _formatter:LogMessageFormatter;
		
		protected var _url:String;
		protected var _buffer:Array;
		protected var _logLevel:int;
		
		public function ServerLogTarget(url:String, logLevel:int =  0x0002,  bufferSize:int = 50, format:String = null) 
		{
			_url = url;
			_logLevel = logLevel;
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
			if (level <= _logLevel)
			{
				sendReport();
			}
		}
		
		protected function sendReport():void 
		{
			if (_url == null) return;
			
			//Could use logRuntimeInfo, but we don't to have to reference stage so we can log fatal errros before added to stage
			var props:Array = [];
			props[0] = check( Capabilities, "supports32BitProcesses" ),
			props[1] = check( Capabilities, "supports64BitProcesses" ),
			props[2] = check( Capabilities, "hasAccessibility"),
			props[3] = check( Capabilities, "hasIME"),
			props[4] = check( Capabilities, "hasAudioEncoder" ),
			props[5] = check( Capabilities, "hasVideoEncoder" ),
			props[6] = check( Capabilities, "avHardwareDisable" );
			props[7] = Object(Capabilities).hasOwnProperty("touchscreenType") ? Capabilities["touchscreenType"] : "none";
			
			var info:String =
					"Player Version: " + Capabilities.version + ( Capabilities.isDebugger ? " (debugger)" : " (release)" )
					+ "\n" +Capabilities.cpuArchitecture + " CPU architecture on OS: " + Capabilities.os
					+ "\nDisplay: " + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY + "@" + Capabilities.screenColor
					+ "\nSupport: 32bit | 64bit | Accessability | IME | AudioEncoder | VideoEncoder | AV hardware disable | Touch Screen"
					+ "\n         {0}   | {1}   | {2}           | {3} | {4}          | {5}          | {6}                 | {7} "
					+ "\nLocale: " + Capabilities.language;
					
			var infoFormatter:LogMessageFormatter = new LogMessageFormatter("{message}");
			var parsedInfo:String = infoFormatter.format("", "", 0, 0, info, props, "");
			
			var data:String = parsedInfo + "\n\t\t" + _buffer.join("\n\t\t");
			_buffer = [];
			var urlLoader:URLLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest(_url);
			var urlVars:URLVariables = new URLVariables();
			urlVars.data = data;
			urlRequest.data = urlVars;
			urlRequest.method = URLRequestMethod.POST;
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleUrlLoaderIoError, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleUrlLoaderSecurityError, false, 0, true);
			urlLoader.load(urlRequest);
		}
		
		protected function check( obj:Object, property: String ): * {
			if( obj.hasOwnProperty(property) ) {
				return "yes";
			}
			return "no ";
		}
		
		private function handleUrlLoaderIoError(e:IOErrorEvent):void 
		{
			
		}
		
		private function handleUrlLoaderSecurityError(e:SecurityErrorEvent):void 
		{
			
		}
		
	}
	

}