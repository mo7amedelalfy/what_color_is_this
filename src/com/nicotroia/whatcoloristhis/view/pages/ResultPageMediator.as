package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
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

	public class ResultPageMediator extends PageBaseMediator
	{
		[Inject]
		public var resultPage:ResultPage;
		
		[Inject]
		public var cameraModel:CameraModel;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		private var _winningColorShape:Shape;
		private var _targetCopy:Bitmap;
		private var _textFormat:TextFormat;
		private var _closestMatch:String;
		
		override public function onRegister():void
		{
			_winningColorShape = new Shape();
			_targetCopy = new Bitmap(cameraModel.targetCopy);
			
			super.onRegister();
			
			resultPage.thisThingTF.text = "";
			resultPage.colorNameTF.text = "";
			
			resultPage.addChildAt(_winningColorShape, 0);
			resultPage.addChild(_targetCopy);
			
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Results"));
			
			trace("loading: http://nicotroia.com/api/what-crayola-is-this/"+cameraModel.winner);
			
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.COLOR_RESULT_LOADING));
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, "Fetching result..."));
			
			urlLoader.load(new URLRequest("http://nicotroia.com/api/what-crayola-is-this/"+cameraModel.winner));
		}
		
		protected function urlLoaderCompleteHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			var json:Object = JSON.parse(urlLoader.data);
			var name:String = json.color_name; //"";
			_closestMatch = json.closest_match;
			
			/*
			for each(var n:String in json.color_names) { 
				name += n + " / ";
			}
			name = name.substr(0,-3);
			*/
			
			trace("ding. " + name);
			trace("closest_match: " + _closestMatch);
			
			resultPage.thisThingTF.text = getRandomComment(); 
			resultPage.colorNameTF.text = name;
			resultPage.closestMatchHexTF.text = "(0x" + _closestMatch + ")";
			
			if(uint("0x"+cameraModel.winner) > 0xAAAAAA) { 
				_textFormat.color = 0x2b2b2b;
			}
			else { 
				_textFormat.color = 0xffffff;
			}
			
			resultPage.thisThingTF.setTextFormat(_textFormat);
			resultPage.colorNameTF.setTextFormat(_textFormat);
			resultPage.closestMatchHexTF.setTextFormat(_textFormat);
			
			colorBackground();
		}
		
		protected function urlLoaderIOErrorHandler(event:IOErrorEvent):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			trace("IOError: " + event.errorID);
		}
		
		protected function urlLoaderSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			trace("SecurityError: " + event.errorID);
		}
		
		override protected function appResizedHandler(event:LayoutEvent):void
		{
			_textFormat = new TextFormat();
			var maxWidth:uint;
			
			trace("result page resized");
			
			if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
				maxWidth = layoutModel.appHeight * 0.25
			}
			else { 
				maxWidth = layoutModel.appWidth * 0.25
			}
			
			resultPage.thisThingTF.width = layoutModel.appWidth;
			resultPage.thisThingTF.x = 0;
			resultPage.thisThingTF.y = layoutModel.appHeight * 0.3;
			
			resultPage.colorNameTF.width = layoutModel.appWidth;
			resultPage.colorNameTF.x = 0;
			resultPage.colorNameTF.y = resultPage.thisThingTF.y + resultPage.thisThingTF.textHeight + 24;
			resultPage.colorNameTF.autoSize = TextFieldAutoSize.CENTER;
			
			resultPage.closestMatchHexTF.width = layoutModel.appWidth;
			resultPage.closestMatchHexTF.x = 0;
			resultPage.closestMatchHexTF.y = resultPage.colorNameTF.y + resultPage.colorNameTF.textHeight + 14;
			
			_targetCopy.width = maxWidth;
			_targetCopy.scaleY = _targetCopy.scaleX;
			_targetCopy.x = 14;
			_targetCopy.y = layoutModel.appHeight - _targetCopy.height - 14;
			
			colorBackground();
		}
		
		private function colorBackground():void
		{
			_winningColorShape.graphics.clear();
			
			if( _closestMatch ) { 
				_winningColorShape.graphics.beginFill( uint("0x"+ _closestMatch), 1.0 );
				_winningColorShape.graphics.drawRect(0, 0, layoutModel.appWidth, layoutModel.appHeight);
				_winningColorShape.graphics.endFill();
			}
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
			
			super.onRemove();
			
			trace("result page removing.");
			
			if( resultPage.contains(_winningColorShape) ) resultPage.removeChild(_winningColorShape);
			if( resultPage.contains(_targetCopy) ) resultPage.removeChild(_targetCopy);
			
			_closestMatch = '';
			_targetCopy = null;
			_winningColorShape = null;
		}
	}
}