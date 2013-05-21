package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.controller.utils.ResultLoader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Actor;

	public class ColorModel extends Actor
	{
		public var hexInQuestion:String;
		public var matchedHex:String;
		public var suggestedName:String;

		private var _simpleResultLoader:ResultLoader;
		private var _ntcResultLoader:ResultLoader;
		private var _crayolaResultLoader:ResultLoader;
		private var _pantoneResultLoader:ResultLoader;
		private var _suggestionLoader:URLLoader;
		private var _onSuggestSuccess:Function;
		private var _onSuggestError:Function;
		
		public function ColorModel()
		{
			
		}
		
		public function whatColorIsThis(hex:String, resultSuccessHandler:Function, resultErrorHandler:Function):void
		{
			//We should combine these separate table results into ONE data set
			
			//always get the simple result
			_simpleResultLoader = new ResultLoader(ResultLoader.SIMPLE, hex, resultSuccessHandler, resultErrorHandler);
			
			if( Settings.fetchNtcResults ) { 
				_ntcResultLoader = new ResultLoader(ResultLoader.NAME_THAT_COLOR, hex, resultSuccessHandler, resultErrorHandler);
			}
			
			if( Settings.fetchCrayolaResults ) { 
				_crayolaResultLoader = new ResultLoader(ResultLoader.CRAYOLA, hex, resultSuccessHandler, resultErrorHandler);
			}
			
			if( Settings.fetchPantoneResults ) { 
				_pantoneResultLoader = new ResultLoader(ResultLoader.PANTONE, hex, resultSuccessHandler, resultErrorHandler);
			}
		}
		
		public function giveSimpleColorsASuggestion(hexInQuestion:String, matchedHex:String, suggestedName:String, successHandler:Function, errorHandler:Function):void
		{
			this.hexInQuestion = hexInQuestion;
			this.matchedHex = matchedHex;
			this.suggestedName = suggestedName;
			this._onSuggestSuccess = successHandler;
			this._onSuggestError = errorHandler;
			
			if( ! suggestedName || suggestedName == '' ) { 
				resetSuggestion();
				
				_onSuggestError();
				
				return;
			}
			
			_suggestionLoader = new URLLoader();
			
			_suggestionLoader.addEventListener(Event.COMPLETE, suggestionLoaderCompleteHandler);
			_suggestionLoader.addEventListener(IOErrorEvent.IO_ERROR, suggestionLoaderIOErrorHandler);
			_suggestionLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, suggestionLoaderSecurityErrorHandler);
			
			var query:String = "?hex=" + this.hexInQuestion + "&matched_hex=" + this.matchedHex + "&suggested_name=" + this.suggestedName;
			var url:String = "http://nicotroia.com/api/suggest-simple-color/" + query;
			
			trace("SuggestionLoader loading: "+ url);
			
			//dispatch notificationEvent.sendingSuggestion
			
			_suggestionLoader.load(new URLRequest(url));
		}
		
		protected function suggestionLoaderSecurityErrorHandler(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, suggestionLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, suggestionLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, suggestionLoaderSecurityErrorHandler);
			
			urlLoader = null;
			_onSuggestError();
		}
		
		protected function suggestionLoaderIOErrorHandler(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, suggestionLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, suggestionLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, suggestionLoaderSecurityErrorHandler);
			
			urlLoader = null;
			_onSuggestError();
		}
		
		protected function suggestionLoaderCompleteHandler(event:Event):void
		{
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, suggestionLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, suggestionLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, suggestionLoaderSecurityErrorHandler);
			
			
			//dispatch notificationEvent.sendingSuggestionFinished
			
			
			var json:Object = JSON.parse(urlLoader.data);
			
			if( json.success == true ) { 
				_onSuggestSuccess();
			}
			else { 
				_onSuggestError();
			}
			
			urlLoader = null;
		}
		
		public function resetSuggestion():void
		{
			this.hexInQuestion = '';
			this.matchedHex = '';
			this.suggestedName = '';
		}
	}
}