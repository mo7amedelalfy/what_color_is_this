package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.controller.events.CameraEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.media.CameraRoll;
	import flash.media.CameraRollBrowseOptions;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.getTimer;
	
	import org.robotlegs.mvcs.Actor;

	public class CameraModel extends Actor
	{
		public var photoData:BitmapData;
		public var targetedPixels:BitmapData;
		public var top5:Array;
		public var chosenWinnerHex:String;
		//public var closestMatchHex:String;
		//public var resultName:String;
		
		protected var _cameraUI:CameraUI;
		protected var _cameraRoll:CameraRoll;
		protected var _imageLoader:Loader;
		protected var _dataSource:IDataInput;
		
		public function CameraModel()
		{
			
		}
		
		public function saveImage(bmd:BitmapData):void
		{
			if( CameraRoll.supportsAddBitmapData ) { 
				trace("saving image to camera roll.");
				
				if( ! _cameraRoll ) _cameraRoll = new CameraRoll();
				
				_cameraRoll.addBitmapData(bmd);
			}
		}
		
		/*
		*
		* CAMERA UI
		*
		*/
		
		public function initCamera():void
		{	
			trace("init camera.");
			
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.CAMERA_LOADING));
			
			if( CameraUI.isSupported ) { 
				_cameraUI = new CameraUI();
				
				_cameraUI.addEventListener(MediaEvent.COMPLETE, cameraPhotoCompleteHandler); 
				_cameraUI.addEventListener(Event.CANCEL, cameraCancelHandler); 
				_cameraUI.addEventListener(ErrorEvent.ERROR, cameraErrorHandler); 
				
				_cameraUI.launch(MediaType.IMAGE); 
			}
			else { 
				trace("This device does not have Camera support");
				
				//force random
				//photoData = generateRandomBitmapData();
				//eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_IMAGE_TAKEN));
				
				eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_IMAGE_FAILED));
			}
		}
		
		protected function cameraCancelHandler(event:Event):void
		{
			_cameraUI.removeEventListener(MediaEvent.COMPLETE, cameraPhotoCompleteHandler); 
			_cameraUI.removeEventListener(Event.CANCEL, cameraCancelHandler); 
			_cameraUI.removeEventListener(ErrorEvent.ERROR, cameraErrorHandler); 
			
			trace("Camera cancelled.");
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_IMAGE_FAILED));
		}
		
		protected function cameraErrorHandler(event:ErrorEvent):void
		{
			_cameraUI.removeEventListener(MediaEvent.COMPLETE, cameraPhotoCompleteHandler); 
			_cameraUI.removeEventListener(Event.CANCEL, cameraCancelHandler); 
			_cameraUI.removeEventListener(ErrorEvent.ERROR, cameraErrorHandler); 
			
			trace("Camera Error. " + event.errorID);
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_IMAGE_FAILED));
		}
		
		protected function cameraPhotoCompleteHandler(event:MediaEvent):void
		{
			_cameraUI.removeEventListener(MediaEvent.COMPLETE, cameraPhotoCompleteHandler); 
			_cameraUI.removeEventListener(Event.CANCEL, cameraCancelHandler); 
			_cameraUI.removeEventListener(ErrorEvent.ERROR, cameraErrorHandler); 
			
			var promise:MediaPromise = event.data;
			
			if( promise.file ) { 
				//iOS does not actually create a file but keeps it in memory, so these would be null.
				trace(promise.file);
				trace(promise.file.name, promise.file.url);
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, filePromiseLoadedHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, filePromiseLoadErrorHandler);
			
			loader.loadFilePromise(promise);
		}
		
		protected function filePromiseLoadErrorHandler(event:IOErrorEvent):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			
			loaderInfo.removeEventListener(Event.COMPLETE, filePromiseLoadedHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, filePromiseLoadErrorHandler);
			
			trace("IOError! " + event.errorID );
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_IMAGE_FAILED));
		}
		
		protected function filePromiseLoadedHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			
			loaderInfo.removeEventListener(Event.COMPLETE, filePromiseLoadedHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, filePromiseLoadErrorHandler);
			
			photoData = Bitmap(event.target.content).bitmapData;
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_IMAGE_TAKEN));
		}
		
		/*
		*
		* CAMERA ROLL
		*
		*/
		
		public function initCameraRoll():void
		{
			trace("init camera roll.");
			
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.CAMERA_ROLL_LOADING));
			
			//force goat
			var bitmap:Bitmap = new Assets.ScreamingGoat() as Bitmap;
			
			photoData = bitmap.bitmapData;
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_SELECTED));
			
			return;
			
			if( CameraRoll.supportsBrowseForImage ) { 
				_cameraRoll = new CameraRoll();
				var options:CameraRollBrowseOptions = new CameraRollBrowseOptions();
				
				_cameraRoll.addEventListener(Event.CANCEL, cameraRollCancelHandler);
				_cameraRoll.addEventListener(MediaEvent.SELECT, mediaSelectHandler);
				
				_cameraRoll.browseForImage( options );
			}
			else { 
				trace("This device does not have Camera Roll support");
				
				//force goat
				var bitmap:Bitmap = new Assets.ScreamingGoat() as Bitmap;
				
				photoData = bitmap.bitmapData;
				
				eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_SELECTED));
				//eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_FAILED));
			}
		}
		
		protected function cameraRollCancelHandler(event:Event):void
		{
			_cameraRoll.removeEventListener(Event.CANCEL, cameraRollCancelHandler);
			_cameraRoll.removeEventListener(MediaEvent.SELECT, mediaSelectHandler);
			
			trace("cancelled.");
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_FAILED));
		}
		
		private function mediaSelectHandler(event:MediaEvent):void
		{
			_cameraRoll.removeEventListener(Event.CANCEL, cameraRollCancelHandler);
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
				
				var bitmap:Bitmap = _imageLoader.contentLoaderInfo.content as Bitmap;
				
				photoData = bitmap.bitmapData;
				
				eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_SELECTED));
			}
		}
		
		protected function mediaLoadFailHandler(event:IOErrorEvent):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, mediaLoadCompleteHandler );
			_imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, mediaLoadFailHandler );
			
			trace("image load fail. Error " + event.errorID);
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_FAILED));
		}
		
		private function mediaLoadCompleteHandler(event:Event):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, mediaLoadCompleteHandler );
			_imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, mediaLoadFailHandler );
			
			trace("load complete.");
			
			var bitmap:Bitmap = event.target.content as Bitmap;
			
			photoData = bitmap.bitmapData;
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_SELECTED));
		}
		
		/*
		*
		* OTHER STUFF
		*
		*/
		
		public function generateRandomBitmapData():BitmapData
		{
			var bmd:BitmapData = new BitmapData(480, 320); //640, 480);
			var seed:Number = Math.floor(Math.random()*100);
			
			bmd.perlinNoise(100, 100, 8, seed, true, true, 7, false, null);
			
			return bmd;
		}
	}
}