package com.nicotroia.whatcoloristhis.controller.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class ResultLoader
	{
		public static const CRAYOLA:String = "Crayola";
		public static const PANTONE:String = "Pantone";
		public static const CRAYOLA_API:String = "what-crayola-is-this";
		public static const PANTONE_API:String = "what-pantone-is-this";
		
		private var _resultType:String;
		private var _resultAPI:String;
		private var _callback:Function;
		
		public function ResultLoader(resultType:String, queryHex:String, callback:Function = null)
		{
			_resultType = resultType;
			_callback = callback;
			
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			if( resultType == CRAYOLA ) _resultAPI = CRAYOLA_API;
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
			json.result_type = _resultType;
			
			if( _resultType == PANTONE ) { 
				json.color_name = "Pantone #" + json.pantone_id;
			}
			
			trace("Ding! " + _resultType, json.color_name);
			
			if( _callback != null ) { 
				_callback(json, this);
			}
			
			urlLoader = null;
			
			//cameraModel.resultName = json.color_name; //"";
			//cameraModel.closestMatchHex = json.closest_match;
			
			/*
			for each(var n:String in json.color_names) { 
			name += n + " / ";
			}
			name = name.substr(0,-3);
			*/
			
			//trace("ding. " + cameraModel.resultName);
			//trace("closest_match: " + cameraModel.closestMatchHex);
			
			/*
			resultPage.vectorPage.thisThingTF.text = getRandomComment(); 
			resultPage.vectorPage.colorNameTF.text = cameraModel.resultName;
			resultPage.vectorPage.closestMatchHexTF.text = "(0x" + cameraModel.closestMatchHex + ")";
			
			if(uint("0x"+cameraModel.chosenWinnerHex) > 0xAAAAAA) { 
			_textFormat.color = 0x2b2b2b;
			}
			else { 
			_textFormat.color = 0xffffff;
			}
			
			resultPage.vectorPage.thisThingTF.setTextFormat(_textFormat);
			resultPage.vectorPage.colorNameTF.setTextFormat(_textFormat);
			resultPage.vectorPage.closestMatchHexTF.setTextFormat(_textFormat);
			*/
			//colorBackground();
			//resultPage.drawResultTexts();
		}
		
		protected function urlLoaderIOErrorHandler(event:IOErrorEvent):void
		{
			//eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			trace("IOError: " + event.errorID);
		}
		
		protected function urlLoaderSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			//eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			trace("SecurityError: " + event.errorID);
		}
	}
}