package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.controller.events.ImageEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.ProgressEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.media.CameraRoll;
	import flash.media.CameraRollBrowseOptions;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.robotlegs.mvcs.Actor;

	public class CameraModel extends Actor
	{
		protected var _cameraUI:CameraUI;
		protected var _cameraRoll:CameraRoll;
		protected var _imageLoader:Loader;
		protected var _dataSource:IDataInput;
		
		private var _cameraMode:Boolean;
		
		public function CameraModel()
		{
			
		}
		
		public function initCamera():void
		{
			_cameraMode = true;
			
			trace("init camera.");
			
			if( CameraUI.isSupported ) { 
				_cameraUI = new CameraUI();
				
				_cameraUI.addEventListener(MediaEvent.COMPLETE, cameraPhotoCompleteHandler); 
				_cameraUI.addEventListener(Event.CANCEL, mediaCancelHandler); 
				_cameraUI.addEventListener(ErrorEvent.ERROR, cameraErrorHandler); 
				
				_cameraUI.launch(MediaType.IMAGE); 
			}
			else { 
				trace("This device does not have Camera support");
			}
		}
		
		protected function cameraErrorHandler(event:ErrorEvent):void
		{
			trace("Camera error. Error" + event.errorID);
		}
		
		protected function cameraPhotoCompleteHandler(event:MediaEvent):void
		{
			var promise:MediaPromise = event.data;
			_dataSource = promise.open();
			
			if( promise.isAsync ) { 
				var eventSource:IEventDispatcher = _dataSource as IEventDispatcher;
				
				eventSource.addEventListener(Event.COMPLETE, cameraMediaLoadCompleteHandler);
			}
			else { 
				readMediaData();
			}
		}
		
		private function cameraMediaLoadCompleteHandler(event:Event):void
		{
			IEventDispatcher(_dataSource).removeEventListener(Event.COMPLETE, cameraMediaLoadCompleteHandler);
			
			trace("camera load complete");
			
			readMediaData();
		}
		
		protected function readMediaData():void
		{
			trace("reading media data");
			
			var imageBytes:ByteArray = new ByteArray();
			
			_dataSource.readBytes( imageBytes );
			
			trace(imageBytes);
		}
		
		/*
		CAMERA ROLL
		*/
		
		public function initCameraRoll():void
		{
			_cameraMode = false;
			
			trace("init camera roll.");
			
			if( CameraRoll.supportsBrowseForImage ) { 
				_cameraRoll = new CameraRoll();
				var options:CameraRollBrowseOptions = new CameraRollBrowseOptions();
				
				_cameraRoll.addEventListener(Event.CANCEL, mediaCancelHandler);
				_cameraRoll.addEventListener(MediaEvent.SELECT, mediaSelectHandler);
				
				_cameraRoll.browseForImage( options );
			}
		}
		
		protected function mediaCancelHandler(event:Event):void
		{
			_cameraRoll.removeEventListener(Event.CANCEL, mediaCancelHandler);
			_cameraRoll.removeEventListener(MediaEvent.SELECT, mediaSelectHandler);
			
			trace("cancelled.");
		}
		
		private function mediaSelectHandler(event:MediaEvent):void
		{
			_cameraRoll.removeEventListener(Event.CANCEL, mediaCancelHandler);
			_cameraRoll.removeEventListener(MediaEvent.SELECT, mediaSelectHandler);
			
			trace("selected.");
			
			var promise:MediaPromise = event.data;
			
			_imageLoader = new Loader();
			
			if( promise.isAsync )
			{
				trace("Asynchronous media promise." );
				_imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, mediaLoadCompleteHandler );
				_imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, mediaLoadFailHandler );
				
				_imageLoader.loadFilePromise( promise );
			}
			else
			{
				trace("Synchronous media promise." );
				_imageLoader.loadFilePromise( promise );
				//this.addChild( loader );
				handleLoadedBitmap( _imageLoader.contentLoaderInfo.content as Bitmap );
			}
		}
		
		protected function mediaLoadFailHandler(event:IOErrorEvent):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, mediaLoadCompleteHandler );
			_imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, mediaLoadFailHandler );
			
			trace("image load fail. Error " + event.errorID);
		}
		
		private function mediaLoadCompleteHandler(event:Event):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, mediaLoadCompleteHandler );
			_imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, mediaLoadFailHandler );
			
			trace("load complete.");
			
			handleLoadedBitmap( event.target.content );
		}
		
		private function handleLoadedBitmap(bitmap:Bitmap):void
		{
			trace(bitmap);
			var bmd:BitmapData = bitmap.bitmapData;
			
			for( var x:uint = 0; x < bmd.width; x++ ) { 
				for( var y:uint = 0; y < bmd.height; y++ ) { 
					//trace("("+ x +","+ y + ") 0x" + bmd.getPixel(x,y).toString(16));
				}
			}
			
			trace("iteration complete");
			
			bmd.applyFilter(bmd, bmd.rect, new Point(), new BlurFilter(16,16,3));
			
			eventDispatcher.dispatchEvent(new ImageEvent(ImageEvent.CAMERA_ROLL_IMAGE_SELECTED, bitmap));
		}
	}
}