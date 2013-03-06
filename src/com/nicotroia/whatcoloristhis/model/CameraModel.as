package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.controller.events.CameraEvent;
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
		public var winner:String;
		public var photoData:BitmapData;
		public var targetCopy:BitmapData;
		
		protected var _cameraUI:CameraUI;
		protected var _cameraRoll:CameraRoll;
		protected var _imageLoader:Loader;
		protected var _dataSource:IDataInput;
		
		public function CameraModel()
		{
			
		}
		
		/*
		*
		* CAMERA
		*
		*/
		
		public function initCamera():void
		{	
			trace("init camera.");
			
			if( CameraUI.isSupported ) { 
				_cameraUI = new CameraUI();
				
				_cameraUI.addEventListener(MediaEvent.COMPLETE, cameraPhotoCompleteHandler); 
				_cameraUI.addEventListener(Event.CANCEL, cameraCancelHandler); 
				_cameraUI.addEventListener(ErrorEvent.ERROR, cameraErrorHandler); 
				
				_cameraUI.launch(MediaType.IMAGE); 
			}
			else { 
				trace("This device does not have Camera support");
				
				photoData = generateRandomBitmapData();
				
				eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_IMAGE_TAKEN));
			}
		}
		
		protected function cameraCancelHandler(event:Event):void
		{
			_cameraUI.removeEventListener(MediaEvent.COMPLETE, cameraPhotoCompleteHandler); 
			_cameraUI.removeEventListener(Event.CANCEL, cameraCancelHandler); 
			_cameraUI.removeEventListener(ErrorEvent.ERROR, cameraErrorHandler); 
			
			trace("Camera cancelled.");
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
		
		protected function cameraErrorHandler(event:ErrorEvent):void
		{
			_cameraUI.removeEventListener(MediaEvent.COMPLETE, cameraPhotoCompleteHandler); 
			_cameraUI.removeEventListener(Event.CANCEL, cameraCancelHandler); 
			_cameraUI.removeEventListener(ErrorEvent.ERROR, cameraErrorHandler); 
			
			trace("Camera Error. " + event.errorID);
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
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
			
			trace("yay");
			
			photoData = Bitmap(event.target.content).bitmapData;
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_IMAGE_TAKEN));
		}
		
		/*
		*
		* CAMERA ROLL
		*
		*/
		
		public function saveImage(bmd:BitmapData):void
		{
			if( CameraRoll.supportsAddBitmapData ) { 
				trace("saving image to camera roll.");
				
				if( ! _cameraRoll ) _cameraRoll = new CameraRoll();
				
				_cameraRoll.addBitmapData(bmd);
			}
		}
		
		public function initCameraRoll():void
		{
			trace("init camera roll.");
			
			if( CameraRoll.supportsBrowseForImage ) { 
				_cameraRoll = new CameraRoll();
				var options:CameraRollBrowseOptions = new CameraRollBrowseOptions();
				
				_cameraRoll.addEventListener(Event.CANCEL, cameraRollCancelHandler);
				_cameraRoll.addEventListener(MediaEvent.SELECT, mediaSelectHandler);
				
				_cameraRoll.browseForImage( options );
			}
		}
		
		protected function cameraRollCancelHandler(event:Event):void
		{
			_cameraRoll.removeEventListener(Event.CANCEL, cameraRollCancelHandler);
			_cameraRoll.removeEventListener(MediaEvent.SELECT, mediaSelectHandler);
			
			trace("cancelled.");
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
			
			photoData = bmd;
			
			eventDispatcher.dispatchEvent(new CameraEvent(CameraEvent.CAMERA_ROLL_IMAGE_SELECTED));
		}
		
		/*
		*
		* OTHER STUFF
		*
		*/
		
		public function generateRandomBitmapData():BitmapData
		{
			var bmd:BitmapData = new BitmapData(640, 480);
			var seed:Number = Math.floor(Math.random()*100);
			
			bmd.perlinNoise(320, 240, 8, seed, true, true, 7, false, null);
			
			return bmd;
		}
	}
}