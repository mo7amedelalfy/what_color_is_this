package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.controller.utils.ColorHelper;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.StageOrientation;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class AreaSelectPageMediator extends PageBaseMediator
	{
		[Inject]
		public var areaSelectPage:AreaSelectPage;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		[Inject]
		public var cameraModel:CameraModel;
		
		private var _image:Bitmap;
		private var _target:Target;
		private var _capturedPixels:Object;
		
		override public function onRegister():void
		{
			_target = new Target();
			
			super.onRegister();
			
			//areaSelectPage.addChild(_fullImage);
			areaSelectPage.addChildAt(_image, 0);
			areaSelectPage.addChildAt(_target, 1);
			
			eventMap.mapListener(areaSelectPage.cancelButton, MouseEvent.CLICK, cancelButtonClickHandler);
			eventMap.mapListener(areaSelectPage.acceptButton, MouseEvent.CLICK, acceptButtonClickHandler);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Select an area to analyze."));
		}
		
		private function acceptButtonClickHandler(event:MouseEvent):void
		{
			var r:Rectangle = _target.getBounds(_image);
			var copy:BitmapData = new BitmapData(uint(r.width), uint(r.height), false, 0);
			var color:uint;
			var hex:String;
			
			trace("snap.");
			trace("target: " + r);
			
			_capturedPixels = new Object();
			copy.copyPixels(_image.bitmapData, r, new Point());
			
			//if we copy outside the bounds of the image, how can the fill be transparent?
			
			for( var currentX:uint = 0; currentX < uint(r.width); currentX++ ) { 
				for( var currentY:uint = 0; currentY < uint(r.height); currentY++ ) { 
					
					color = copy.getPixel(currentX, currentY);
					
					if( color === 0 ) continue;
					
					hex = ColorHelper.colorToHexString(color);
					
					_capturedPixels[hex] = (( _capturedPixels[hex] ) ? _capturedPixels[hex] + 1 : 1);
					
					//trace(currentX, currentY, hex);
				}
			}
			
			
			var winner:String;
			var currentScore:uint;
			
			for( var key:String in _capturedPixels ) { 
				currentScore = _capturedPixels[key];
				
				if( ! winner ) winner = key;
				
				if( currentScore > _capturedPixels[winner] ) { 
					winner = key;
				}
			}
			
			trace("most used color: 0x" + winner + " with " + _capturedPixels[winner]);
			
			cameraModel.winner = winner;
			cameraModel.targetCopy = copy;
			
			//cameraModel.saveImage(bmd);
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Result));
		}
		
		private function cancelButtonClickHandler(event:MouseEvent):void
		{
			trace("cancel");
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
		
		override protected function appResizedHandler(event:LayoutEvent):void
		{
			var targetSize:Number;
			var isPortrait:Boolean = (cameraModel.photoData.height / cameraModel.photoData.width) > 1.0;
			var maxLength:int = Math.min(contextView.stage.stageWidth - 28, contextView.stage.stageHeight - layoutModel.navBarHeight - 28);
			var scale:Number;
			
			trace("area select page resized");
			
			if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
				scale = maxLength / cameraModel.photoData.height;
				targetSize = contextView.stage.stageHeight * 0.42;
								
				_target.width = targetSize;
				_target.scaleY = _target.scaleX;
				_target.x = (contextView.stage.stageWidth * 0.5) - (_target.width * 0.5);
				_target.y = (contextView.stage.stageHeight * 0.5) - (_target.height * 0.5);
				
				_image.y = contextView.stage.stageHeight;
				_image.rotation = -90;
				
				areaSelectPage.actionBar.height = contextView.stage.stageHeight + 1;
				areaSelectPage.actionBar.width = 85;
				areaSelectPage.actionBar.x = contextView.stage.stageWidth - areaSelectPage.actionBar.width;
				areaSelectPage.actionBar.y = 0;
				
			}
			else { 
				scale = maxLength / cameraModel.photoData.width;
				targetSize = (contextView.stage.stageWidth - layoutModel.navBarHeight) * 0.42;
				
				_target.width = targetSize;
				_target.scaleY = _target.scaleX;
				_target.x = (contextView.stage.stageWidth * 0.5) - (_target.width * 0.5);
				_target.y = layoutModel.navBarHeight + (((contextView.stage.stageHeight - layoutModel.navBarHeight) * 0.5) - (_target.height * 0.5));
				
				areaSelectPage.actionBar.height = 85;
				areaSelectPage.actionBar.width = contextView.stage.stageWidth + 1;
				areaSelectPage.actionBar.x = 0;
				areaSelectPage.actionBar.y = contextView.stage.stageHeight - areaSelectPage.actionBar.height;
				
			}
			
			areaSelectPage.backButton.height = areaSelectPage.actionBar.height * 0.70;
			areaSelectPage.backButton.scaleX = areaSelectPage.backButton.scaleY;
			areaSelectPage.backButton.x = 14;
			areaSelectPage.backButton.y = (layoutModel.navBarHeight - areaSelectPage.backButton.height) * 0.5;
			
			areaSelectPage.cancelButton.height = areaSelectPage.actionBar.height * 0.70;
			areaSelectPage.cancelButton.scaleX = areaSelectPage.cancelButton.scaleY;
			areaSelectPage.cancelButton.x = 14;
			areaSelectPage.cancelButton.y = areaSelectPage.actionBar.y + ((areaSelectPage.actionBar.height - areaSelectPage.cancelButton.height) * 0.5);
			
			areaSelectPage.acceptButton.height = areaSelectPage.actionBar.height * 0.70;
			areaSelectPage.acceptButton.scaleX = areaSelectPage.acceptButton.scaleY;
			areaSelectPage.acceptButton.x = contextView.stage.stageWidth - areaSelectPage.acceptButton.width - 14;
			areaSelectPage.acceptButton.y = areaSelectPage.actionBar.y + ((areaSelectPage.actionBar.height - areaSelectPage.acceptButton.height) * 0.5);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			
			var smallBMD:BitmapData = new BitmapData(cameraModel.photoData.width * scale, cameraModel.photoData.height * scale, true);
			smallBMD.draw(cameraModel.photoData, matrix, null, null, null, true);
			
			_image = new Bitmap(smallBMD, PixelSnapping.NEVER, true);
			
			_image.x = 14;
			_image.y = layoutModel.navBarHeight + 14;
		}
		
		override public function onRemove():void
		{
			if( areaSelectPage.contains(_image) ) areaSelectPage.removeChild(_image);
			if( areaSelectPage.contains(_target) ) areaSelectPage.removeChild(_target);
			
			_image = null;
			_target = null;
		}
	}
}