package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.controller.utils.ColorHelper;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.text.TextField;

	public class WelcomePageMediator extends PageBaseMediator
	{
		[Inject]
		public var welcomePage:WelcomePage;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		[Inject]
		public var cameraModel:CameraModel;
		
		private var _camera:Camera;
		private var _cameraView:Video;
		private var _cameraRect:Rectangle;
		private var _capturedPixels:Object;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(welcomePage.takePhotoButton, MouseEvent.CLICK, takePhotoButtonClickHandler);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "What Color <i>Is</i> This?"));
		}
		
		/*
		private function initCamera():void
		{
			trace("Init camera.");
			
			if( Camera.isSupported ) { 
				_camera = Camera.getCamera();
				
				if( ! _camera ) { 
					//camera in use or disabled
					//display oops
				}
				else if( _camera.muted ) { 
					//user denied the application access to camera
					//display oops
				}
				else { 
					attachCamera();
				}
			}
			else { 
				//no camera on this device
				//display oops 
			}
		}
		
		private function attachCamera():void
		{
			trace("Attach camera.");
			
			if( contextView.stage.stageWidth > contextView.stage.stageHeight ) { 
				_cameraRect = new Rectangle(0, 0, contextView.stage.stageWidth, contextView.stage.stageHeight);
			}
			else { 
				//Camera is landscape only.
				_cameraRect = new Rectangle(0, layoutModel.navBarHeight, contextView.stage.stageHeight, contextView.stage.stageWidth);
			}
			
			trace(" Camera rect: " + _cameraRect);
			
			_cameraView = new Video(_cameraRect.width, _cameraRect.height);
			_cameraView.x = _cameraRect.x;
			_cameraView.y = _cameraRect.y;
			
			welcomePage.addChildAt(_cameraView, 0);
			
			_cameraView.attachCamera(_camera);
			
			_camera.setMode(_cameraRect.width, _cameraRect.height, 15); 
			
			appResizedHandler(null);
		}
		*/
		
		private function takePhotoButtonClickHandler(event:MouseEvent):void
		{
			cameraModel.initCamera(); 
			
			return;
			
			if( _camera ) { 
				if( _camera.muted ) { 
					//display application permissions dialog
					Security.showSettings(SecurityPanel.PRIVACY);
					
					_camera.addEventListener(StatusEvent.STATUS, permissionStatusHandler);
				}
				else { 
					//do everything areaSelectPageDoes
					
					eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Result));
				}
			}
		}
		
		protected function permissionStatusHandler(event:StatusEvent):void
		{
			if(event.code == "Camera.Unmuted") {
				_camera.removeEventListener(StatusEvent.STATUS, permissionStatusHandler);
				
				//attachCamera(); 
			}
		}
		
		override protected function appResizedHandler(event:LayoutEvent):void
		{
			trace("welcome page resized");
			
			var photoButtonWidth:Number;
			
			welcomePage.directionsTF.x = 14;
			welcomePage.directionsTF.y = layoutModel.navBarHeight + 14;
			
			if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
				welcomePage.actionBar.gotoAndStop(2);
				welcomePage.actionBar.height = contextView.stage.stageHeight + 2;
				welcomePage.actionBar.width = 85;
				welcomePage.actionBar.x = contextView.stage.stageWidth - welcomePage.actionBar.width + 1;
				welcomePage.actionBar.y = 0;
				
				photoButtonWidth = (contextView.stage.stageHeight * 0.3);
				
				welcomePage.takePhotoButton.width = photoButtonWidth;
				welcomePage.takePhotoButton.scaleY = welcomePage.takePhotoButton.scaleX;
				welcomePage.takePhotoButton.x = contextView.stage.stageWidth - welcomePage.takePhotoButton.width - 10;
				welcomePage.takePhotoButton.y = (contextView.stage.stageHeight * 0.5) - (welcomePage.takePhotoButton.height * 0.5);
				
				welcomePage.aboutPageButton.x = welcomePage.actionBar.x + 14;
				welcomePage.aboutPageButton.y = contextView.stage.stageHeight - welcomePage.aboutPageButton.height - 14;
				
				welcomePage.directionsTF.width = contextView.stage.stageWidth - welcomePage.actionBar.width - 28;
				welcomePage.directionsTF.height = contextView.stage.stageHeight - welcomePage.directionsTF.y - 14;
			}
			else { 
				welcomePage.actionBar.gotoAndStop(1);
				welcomePage.actionBar.height = 85;
				welcomePage.actionBar.width = contextView.stage.stageWidth + 2;
				welcomePage.actionBar.x = 0;
				welcomePage.actionBar.y = contextView.stage.stageHeight - welcomePage.actionBar.height + 1;
				
				photoButtonWidth = (contextView.stage.stageWidth * 0.3);
				
				welcomePage.takePhotoButton.width = photoButtonWidth;
				welcomePage.takePhotoButton.scaleY = welcomePage.takePhotoButton.scaleX;
				welcomePage.takePhotoButton.x = (contextView.stage.stageWidth * 0.5) - (welcomePage.takePhotoButton.width * 0.5);
				welcomePage.takePhotoButton.y = contextView.stage.stageHeight - welcomePage.takePhotoButton.height - 10;
				
				welcomePage.aboutPageButton.x = 14;
				welcomePage.aboutPageButton.y = welcomePage.actionBar.y + 14;
				
				welcomePage.directionsTF.width = contextView.stage.stageWidth - 28;
				welcomePage.directionsTF.height = contextView.stage.stageHeight - welcomePage.directionsTF.y - 14;
			}
			
			//trace(targetSize);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			trace("welcome page removing.");
			
			if( _cameraView ) { 
				_cameraView.attachCamera(null);
				welcomePage.removeChild(_cameraView);
			}
			
			_camera = null;
			_cameraView = null;
		}
		
	}
}