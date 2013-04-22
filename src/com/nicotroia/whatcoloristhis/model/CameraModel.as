package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.controller.events.CameraEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.utils.ExifUtils;
	
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
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.getTimer;
	
	import jp.shichiseki.exif.ExifInfo;
	import jp.shichiseki.exif.ExifLoader;
	import jp.shichiseki.exif.IFD;
	
	import org.robotlegs.mvcs.Actor;

	public class CameraModel extends Actor
	{
		public var photoData:BitmapData;
		public var targetedPixels:BitmapData;
		public var top5:ColorLinkedList; //Vector.<String>;
		public var chosenWinnerHex:String;
		//public var closestMatchHex:String;
		//public var resultName:String;
		
		protected var _cameraUI:CameraUI;
		protected var _cameraRoll:CameraRoll;
		protected var _imageLoader:Loader;
		protected var _dataSource:IDataInput;
		protected var _exifLoader:ExifLoader;
		protected var _mediaPromise:MediaPromise;
		protected var _exif:ExifInfo;
		
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
			
			reset();
			
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.CAMERA_LOADING));
			
			if( CameraUI.isSupported ) { 
				_imageLoader = new Loader();
				_cameraUI = new CameraUI();
				
				_cameraUI.addEventListener(MediaEvent.COMPLETE, cameraPhotoCompleteHandler); 
				_cameraUI.addEventListener(Event.CANCEL, cameraCancelHandler); 
				_cameraUI.addEventListener(ErrorEvent.ERROR, cameraErrorHandler); 
				
				_cameraUI.launch(MediaType.IMAGE); 
			}
			else { 
				trace("This device does not have Camera support");
				
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
			
			_mediaPromise = event.data;
			
			if( _mediaPromise.file ) { 
				trace("There is a mediaPromise.file. This is an android?");
				//android
				_exifLoader = new ExifLoader();
				_exifLoader.addEventListener(Event.COMPLETE, cameraExifLoadCompleteHandler );
				_exifLoader.load( new URLRequest( _mediaPromise.file.url ) );
			}
			else { 
				trace("No mediaPromise.file. iOS?");
				//iOS does not actually create a file but keeps it in memory, so these would be null.
				
				//starts to load raw file data
				_dataSource = _mediaPromise.open();
				
				if( _mediaPromise.isAsync )
				{
					trace("Asynchronous media promise." );
					var eventSource:IEventDispatcher = _dataSource as IEventDispatcher;
					eventSource.addEventListener( Event.COMPLETE, cameraUIMediaLoadCompleteHandler );
				}
				else
				{
					trace("Synchronous media promise." );
					//data is immediately available
					cameraUIMediaLoadCompleteHandler(null);
				}
			}
			
		}
		
		private function cameraExifLoadCompleteHandler(event:Event):void
		{
			//android
			_exifLoader.removeEventListener(Event.COMPLETE, cameraExifLoadCompleteHandler );
			
			_imageLoader.unload();
			
			_imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, cameraUIBytesLoadComplete );
			_imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, cameraUIBytesLoadFailHandler );
			
			_imageLoader.loadFilePromise( _mediaPromise );
		}
		
		private function cameraUIMediaLoadCompleteHandler(event:Event):void
		{
			if( event ) { 
				//was asynch..
				var eventSource:IEventDispatcher = event.target as IEventDispatcher;           
				eventSource.removeEventListener( Event.COMPLETE, cameraUIMediaLoadCompleteHandler );  
			}
			
			trace("media promise load complete.");
			
			var data:ByteArray = new ByteArray();
			
			_dataSource.readBytes(data);
			
			_exif = new ExifInfo(data);
			
			_imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, cameraUIBytesLoadComplete );
			_imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, cameraUIBytesLoadFailHandler );
			
			_imageLoader.loadBytes(data);
		}
		
		protected function cameraUIBytesLoadFailHandler(event:IOErrorEvent):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, cameraUIBytesLoadComplete );
			_imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, cameraUIBytesLoadFailHandler );
			
			trace("load bytes IOError: " + event.errorID);
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_IMAGE_FAILED));
		}
		
		private function cameraUIBytesLoadComplete(event:Event):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, cameraUIBytesLoadComplete );
			_imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, cameraUIBytesLoadFailHandler );
			
			trace("load bytes complete!");
			
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			//var bitmapData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
			//bitmapData.draw(loaderInfo.loader);
			
			if( ! _exif ) { 
				//android
				_exif = _exifLoader.exif;
			}
			
			var bitmap:Bitmap;
			if( ! _exif.ifds ) { 
				trace("Exif validation failed :( something wrong with the image?");
				//validation failed... happens to some photos on android incredible...
				bitmap = Bitmap(loaderInfo.content);
			}
			else { 
				//wonderful.
				bitmap = ExifUtils.getEyeOrientedBitmap( Bitmap(loaderInfo.content), _exif.ifds );
			}
			
			photoData = bitmap.bitmapData;
			
			//only on ios...?
			trace("SAVING BITMAPDATA!!!!!!");
			saveImage(photoData);
			
			_imageLoader.unload();
			loaderInfo = null;
			//bitmapData = null;
			
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
			
			reset();
			
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.CAMERA_ROLL_LOADING));
			
			if( CameraRoll.supportsBrowseForImage ) { 
				_imageLoader = new Loader();
				
				_cameraRoll = new CameraRoll();
				
				var options:CameraRollBrowseOptions = new CameraRollBrowseOptions();
				
				_cameraRoll.addEventListener(Event.CANCEL, cameraRollCancelHandler);
				_cameraRoll.addEventListener(MediaEvent.SELECT, mediaSelectHandler);
				
				_cameraRoll.browseForImage( options );
			}
			else { 
				trace("This device does not have Camera Roll support");
				
				eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_FAILED));
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
			
			trace("Selected.");
			
			_mediaPromise = event.data;
			
			if( _mediaPromise.file ) { 
				trace("There is a mediaPromise.file. This is an android?");
				//android
				_exifLoader = new ExifLoader();
				_exifLoader.addEventListener(Event.COMPLETE, cameraRollExifLoadCompleteHandler );
				_exifLoader.load( new URLRequest( _mediaPromise.file.url ) );
			}
			else { 
				trace("No mediaPromise.file. iOS?");
				
				//starts to load raw file data
				_dataSource = _mediaPromise.open();
				
				if( _mediaPromise.isAsync )
				{
					trace("Asynchronous media promise." );
					var eventSource:IEventDispatcher = _dataSource as IEventDispatcher;
					eventSource.addEventListener( Event.COMPLETE, cameraRollMediaLoadCompleteHandler );
				}
				else
				{
					trace("Synchronous media promise." );
					//data is immediately available
					cameraRollMediaLoadCompleteHandler(null);
				}
			}
		}
		
		private function cameraRollExifLoadCompleteHandler(event:Event):void
		{
			//android
			_exifLoader.removeEventListener(Event.COMPLETE, cameraRollExifLoadCompleteHandler );
			
			_imageLoader.unload();
			
			_imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, cameraRollBytesLoadComplete );
			_imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, cameraRollBytesLoadFailHandler );
			
			_imageLoader.loadFilePromise( _mediaPromise );
		}
		
		private function cameraRollMediaLoadCompleteHandler(event:Event):void
		{
			if( event ) { 
				//was asynch..
				var eventSource:IEventDispatcher = event.target as IEventDispatcher;           
				eventSource.removeEventListener( Event.COMPLETE, cameraRollMediaLoadCompleteHandler );  
			}
			
			trace("media promise load complete.");
			
			var data:ByteArray = new ByteArray();
			
			_dataSource.readBytes(data);
			
			_exif = new ExifInfo(data);

			_imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, cameraRollBytesLoadComplete );
			_imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, cameraRollBytesLoadFailHandler );
			
			_imageLoader.loadBytes(data);
		}
		
		protected function cameraRollBytesLoadFailHandler(event:IOErrorEvent):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, cameraRollBytesLoadComplete );
			_imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, cameraRollBytesLoadFailHandler );
			
			trace("load bytes IOError: " + event.errorID);
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_FAILED));
		}
		
		private function cameraRollBytesLoadComplete(event:Event):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, cameraRollBytesLoadComplete );
			_imageLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, cameraRollBytesLoadFailHandler );
			
			trace("load bytes complete!");
			
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			//var bitmapData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
			//bitmapData.draw(loaderInfo.loader);
			
			if( ! _exif ) { 
				//android
				_exif = _exifLoader.exif;
			}
			
			var bitmap:Bitmap;
			if( ! _exif.ifds ) { 
				trace("Exif validation failed :( something wrong with the image?");
				//validation failed... happens to some photos on android incredible...
				bitmap = Bitmap(loaderInfo.content);
			}
			else { 
				//wonderful.
				bitmap = ExifUtils.getEyeOrientedBitmap( Bitmap(loaderInfo.content), _exif.ifds );
			}
			
			photoData = bitmap.bitmapData;
			
			_imageLoader.unload();
			loaderInfo = null;
			//bitmapData = null;
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_SELECTED));
		}
		
		/*
		*
		* COLOR SPECTRUM CHART
		*
		*/
		
		public function initColorSpectrum(bitmap:Bitmap):void
		{
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
			
			bmd.perlinNoise(200, 200, 6, seed, true, true, 7, false, null);
			
			return bmd;
		}
		
		public function reset():void
		{
			_exif = null;
			_exifLoader = null;
			_mediaPromise = null;
			_dataSource = null;
		}
	}
}