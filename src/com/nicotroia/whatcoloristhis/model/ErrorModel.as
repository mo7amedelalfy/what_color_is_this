package com.nicotroia.whatcoloristhis.model
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import org.robotlegs.mvcs.Actor;
	
	public class ErrorModel extends Actor
	{
		public var file:File;
		public var fileStream:FileStream;
		
		private var _errors:Array = [];
		private var _urlLoader:URLLoader;
		private var _errorSendCallback:Function;
		
		public function ErrorModel()
		{
			file = File.applicationStorageDirectory.resolvePath("Errors.json");
			
			fileStream = new FileStream();
		}
		
		public function get errors():Array { 
			if( ! _errors ) { 
				readErrors();
			}
			
			return _errors;
		}
		
		public function readErrors():Array
		{
			if( file.exists ) { 
				fileStream.open(file, FileMode.READ);
				
				var contents:String = fileStream.readMultiByte(fileStream.bytesAvailable, "utf-8");
				fileStream.close();
				
				var array:Array = JSON.parse(contents) as Array;
				
				return array;
			}
			
			return null;
		}
		
		public function addError(message:String):void
		{
			_errors[_errors.length] = message;
		}
		
		public function writeErrors():void
		{
			var json:String = JSON.stringify(_errors);
			
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(json);
			fileStream.close();
		}
		
		public function resetErrors():void
		{
			_errors = [];
			
			writeErrors();
		}
		
		public function sendErrorsToServer(message:String, callback:Function):void
		{
			_errorSendCallback = callback;
			
			_urlLoader = new URLLoader();
			
			_urlLoader.addEventListener(Event.COMPLETE, errorSendCompleteHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorSendIOErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorSendSecurityErrorHandler);
			
			var query:String = "?os=" + Capabilities.os + "&manufacturer=" + Capabilities.manufacturer + "&errors=" + message;
			var url:String = "http://nicotroia.com/api/report-what-color-is-this-errors/" + query;
			
			trace("ErrorModel loading: " + url);
			
			_urlLoader.load( new URLRequest(url) );
		}
		
		protected function errorSendSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, errorSendCompleteHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorSendIOErrorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorSendSecurityErrorHandler);
			
			trace("ErrorModel Security Error: " + event.errorID + " " + event.type);
			
			_errorSendCallback(false);
		}
		
		protected function errorSendIOErrorHandler(event:IOErrorEvent):void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, errorSendCompleteHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorSendIOErrorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorSendSecurityErrorHandler);
			
			trace("ErrorModel IO Error: " + event.errorID + " " + event.type);
			
			_errorSendCallback(false);
		}
		
		protected function errorSendCompleteHandler(event:Event):void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, errorSendCompleteHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorSendIOErrorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorSendSecurityErrorHandler);
			
			trace("ErrorModel sending successful.");
			
			_errorSendCallback(true);
		}
	}
}