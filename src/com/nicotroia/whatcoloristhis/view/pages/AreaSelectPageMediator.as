package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.display.Bitmap;

	public class AreaSelectPageMediator extends PageBaseMediator
	{
		[Inject]
		public var areaSelectPage:AreaSelectPage;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		[Inject]
		public var cameraModel:CameraModel;
		
		private var _image:Bitmap;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			_image = new Bitmap(cameraModel.photoData);
			
			var isPortrait:Boolean = (cameraModel.photoData.height/cameraModel.photoData.width) > 1.0;
			var forRatio:int = Math.min(contextView.stage.stageHeight - layoutModel.navBarHeight, contextView.stage.stageWidth);
			var ratio:Number;
			
			if (isPortrait) {
				ratio = forRatio/cameraModel.photoData.width;
			} else {
				ratio = forRatio/cameraModel.photoData.height;
			}
			
			_image.width = cameraModel.photoData.width * ratio;
			_image.height = cameraModel.photoData.height * ratio;
			_image.x = 0;
			_image.y = layoutModel.navBarHeight;
			
			if( ! isPortrait ) {
				_image.y = contextView.stage.stageHeight;
				_image.rotation = -90;
			}
			
			areaSelectPage.addChild(_image);
		}
		
		override protected function appResizedHandler(event:LayoutEvent):void
		{
			trace("area select page resized");
			
			areaSelectPage.backButton.height = layoutModel.navBarHeight * 0.70;
			areaSelectPage.backButton.scaleX = areaSelectPage.backButton.scaleY;
			areaSelectPage.backButton.x = 14;
			areaSelectPage.backButton.y = (layoutModel.navBarHeight - areaSelectPage.backButton.height) * 0.5;
			
			if( _image ) { 
				_image.y = layoutModel.navBarHeight;
			}
		}
		
		override public function onRemove():void
		{
			
		}
	}
}