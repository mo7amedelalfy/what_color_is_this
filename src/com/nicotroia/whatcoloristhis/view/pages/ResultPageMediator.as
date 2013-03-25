package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class ResultPageMediator extends PageBaseMediator
	{
		[Inject]
		public var resultPage:ResultPage;
		
		//private var _winningColorShape:Shape;
		private var _textFormat:TextFormat;
		//private var _closestMatch:String;
		
		override public function onRegister():void
		{
			_textFormat = new TextFormat();
			//_winningColorShape = new Shape();
			//_targetCopy = new Bitmap(cameraModel.targetCopy);
			
			super.onRegister();
			
			//resultPage.thisThingTF.text = "";
			//resultPage.colorNameTF.text = "";
			
			//resultPage.addChildAt(_winningColorShape, 0);
			//resultPage.addChild(_targetCopy);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Results"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, resultPage.doneButton));
			
			resultPage.reset();
				
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(flash.events.Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			eventMap.mapStarlingListener(resultPage, starling.events.Event.TRIGGERED, resultPageTriggeredHandler);
			resultPage.doneButton.addEventListener(starling.events.Event.TRIGGERED, doneButtonTriggeredHandler);
			
			trace("loading: http://nicotroia.com/api/what-crayola-is-this/"+cameraModel.chosenWinnerHex);
			
			//eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.COLOR_RESULT_LOADING));
			//eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, "Fetching result..."));
			
			urlLoader.load(new URLRequest("http://nicotroia.com/api/what-crayola-is-this/"+cameraModel.chosenWinnerHex));
			
		}
		
		private function doneButtonTriggeredHandler(event:starling.events.Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
		
		private function resultPageTriggeredHandler(event:starling.events.Event):void
		{
			var button:DisplayObject = event.target as DisplayObject;
			
		}
		
		protected function urlLoaderCompleteHandler(event:flash.events.Event):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			var json:Object = JSON.parse(urlLoader.data);
			cameraModel.resultName = json.color_name; //"";
			cameraModel.closestMatchHex = json.closest_match;
			
			/*
			for each(var n:String in json.color_names) { 
				name += n + " / ";
			}
			name = name.substr(0,-3);
			*/
			
			trace("ding. " + cameraModel.resultName);
			trace("closest_match: " + cameraModel.closestMatchHex);
			
			resultPage.drawWinningColor(layoutModel, cameraModel);
			
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
			
			//colorBackground();
			resultPage.drawResultTexts();
		}
		
		protected function urlLoaderIOErrorHandler(event:IOErrorEvent):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			trace("IOError: " + event.errorID);
		}
		
		protected function urlLoaderSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(flash.events.Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			trace("SecurityError: " + event.errorID);
		}
		
		private function getRandomComment():String
		{
			var arr:Vector.<String> = new <String>[
				"That's",
				"That is",
				"That thing's",
				"That thing is",
				"This is", 
				"This thing is", 
				"This is definitely",
				"Haha, this is",
				"Lol, that's"
			];
			
			return arr[uint(Math.random() * arr.length)];
		}
		
		override public function onRemove():void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			eventMap.unmapStarlingListener(resultPage, starling.events.Event.TRIGGERED, resultPageTriggeredHandler);
			resultPage.doneButton.removeEventListener(starling.events.Event.TRIGGERED, doneButtonTriggeredHandler);
			
			resultPage.reset();
			
			super.onRemove();
			
			trace("result page removing.");
			
			//if( resultPage.contains(_winningColorShape) ) resultPage.removeChild(_winningColorShape);
			//if( resultPage.contains(_targetCopy) ) resultPage.removeChild(_targetCopy);
			
			//_closestMatch = '';
			//_targetCopy = null;
			//_winningColorShape = null;
		}
	}
}