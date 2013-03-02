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
			
			trace("loading: http://nicotroia.com/api/what-color-is-this/"+cameraModel.winner);
			
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.COLOR_RESULT_LOADING));
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, "Fetching result..."));
			
			urlLoader.load(new URLRequest("http://nicotroia.com/api/what-color-is-this/"+cameraModel.winner));
		}
		
		protected function urlLoaderCompleteHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			var urlLoader:URLLoader = event.target as URLLoader;
			
			urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			
			var json:Object = JSON.parse(urlLoader.data);
			var name:String = "";
			
			for each(var n:String in json.color_names) { 
				name += n + " / ";
			}
			name = name.substr(0,-3);
			
			trace("ding. " + name);
			
			resultPage.thisThingTF.text = getRandomComment(); 
			resultPage.colorNameTF.text = name;
			
			if(uint("0x"+cameraModel.winner) > 0xAAAAAA) { 
				_textFormat.color = 0x2b2b2b;
			}
			else { 
				_textFormat.color = 0xffffff;
			}
			
			resultPage.thisThingTF.setTextFormat(_textFormat);
			resultPage.colorNameTF.setTextFormat(_textFormat);	
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
				maxWidth = contextView.stage.stageHeight * 0.25
			}
			else { 
				maxWidth = contextView.stage.stageWidth * 0.25
			}
			
			resultPage.thisThingTF.width = contextView.stage.stageWidth;
			resultPage.thisThingTF.x = 0;
			resultPage.thisThingTF.y = contextView.stage.stageHeight * 0.3;
			
			resultPage.colorNameTF.width = contextView.stage.stageWidth;
			resultPage.colorNameTF.x = 0;
			resultPage.colorNameTF.y = resultPage.thisThingTF.y + resultPage.thisThingTF.height + 24;
			
			_targetCopy.width = maxWidth;
			_targetCopy.scaleY = _targetCopy.scaleX;
			_targetCopy.x = 14;
			_targetCopy.y = contextView.stage.stageHeight - _targetCopy.height - 14;
			
			_winningColorShape.graphics.clear();
			_winningColorShape.graphics.beginFill( uint("0x"+ cameraModel.winner), 1.0 );
			_winningColorShape.graphics.drawRect(0, 0, contextView.stage.stageWidth, contextView.stage.stageHeight);
			_winningColorShape.graphics.endFill();
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
		}
	}
}