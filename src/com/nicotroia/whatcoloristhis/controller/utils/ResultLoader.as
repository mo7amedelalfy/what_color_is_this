package com.nicotroia.whatcoloristhis.controller.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class ResultLoader
	{
		public static const SIMPLE:String = "Simple";
		public static const SIMPLE_API:String = "what-color-is-this";
		public static const NAME_THAT_COLOR:String = "Name That Color";
		public static const NAME_THAT_COLOR_API:String = "what-ntc-is-this";
		public static const CRAYOLA:String = "Crayola";
		public static const CRAYOLA_API:String = "what-crayola-is-this";
		public static const PANTONE:String = "Pantone";
		public static const PANTONE_API:String = "what-pantone-is-this";
		
		public var resultType:String;
		
		private var _resultAPI:String;
		private var _onSuccess:Function;
		private var _onError:Function;
		
		public function ResultLoader(resultType:String, queryHex:String, onSuccess:Function = null, onError:Function = null)
		{
			this.resultType = resultType;
			_onSuccess = onSuccess;
			_onError = onError;
			
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			if( resultType == SIMPLE ) _resultAPI = SIMPLE_API;
			else if( resultType == NAME_THAT_COLOR ) _resultAPI = NAME_THAT_COLOR_API;
			else if( resultType == CRAYOLA ) _resultAPI = CRAYOLA_API;
			else if( resultType == PANTONE ) _resultAPI = PANTONE_API;
			
			var url:String = "http://nicotroia.com/api/"+ _resultAPI +"/"+ queryHex;
			
			trace("ResultLoader loading: "+ url);
			
			urlLoader.load(new URLRequest(url));
		}
		
		protected function urlLoaderCompleteHandler(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			var json:Object = JSON.parse(urlLoader.data);
			json.result_type = resultType;
			
			if( resultType == PANTONE ) { 
				json.color_name = "Pantone #" + json.pantone_id;
			}
			
			trace("Ding! " + resultType, json.color_name);
			
			if( _onSuccess != null ) { 
				_onSuccess(json, this);
			}
			
			urlLoader = null;
		}
		
		protected function urlLoaderIOErrorHandler(event:IOErrorEvent):void
		{
			//eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			trace("IOError: " + event.errorID);
			
			_onError(this);
		}
		
		protected function urlLoaderSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			//eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			trace("SecurityError: " + event.errorID);
			
			_onError(this);
		}
	}
}