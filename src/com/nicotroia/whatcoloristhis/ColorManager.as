package com.nicotroia.whatcoloristhis
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.ProgressEvent;
	import flash.media.CameraRoll;
	import flash.media.CameraRollBrowseOptions;
	import flash.media.MediaPromise;

	public class ColorManager
	{
		public function ColorManager()
		{
			
		}
		
		public function initCamera():void
		{
			trace("init camera.");
			
		}
		
		public function initCameraRoll():void
		{
			trace("init camera roll.");
			if( CameraRoll.supportsBrowseForImage ) { 
				var roll:CameraRoll = new CameraRoll();
				var options:CameraRollBrowseOptions = new CameraRollBrowseOptions();
				
				roll.addEventListener(Event.CANCEL, mediaCancelHandler);
				roll.addEventListener(MediaEvent.SELECT, mediaSelectHandler);
				
				roll.browseForImage( options );
			}
		}
		
		protected function mediaCancelHandler(event:Event):void
		{
			trace("cancelled.");
		}
		
		private function mediaSelectHandler(event:MediaEvent):void
		{
			trace("selected.");
			var promise:MediaPromise = event.data;
			
			var loader:Loader = new Loader();
			
			if( promise.isAsync )
			{
				trace("Asynchronous media promise." );
				loader.contentLoaderInfo.addEventListener( Event.COMPLETE, mediaLoadCompleteHandler );
				loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, mediaLoadFailHandler );
				
				loader.loadFilePromise( promise );
			}
			else
			{
				trace("Synchronous media promise." );
				loader.loadFilePromise( promise );
				//this.addChild( loader );
				handleLoadedFile( loader );
			}
		}
		
		protected function mediaLoadFailHandler(event:IOErrorEvent):void
		{
			trace("image load fail.");
		}
		
		private function mediaLoadCompleteHandler(event:Event):void
		{
			trace("load complete.");
			handleLoadedFile( event.target as Loader );
		}
		
		private function handleLoadedFile(loader:Loader):void
		{
			var image:DisplayObject = loader.content;
			
			trace(image);
		}
	}
}