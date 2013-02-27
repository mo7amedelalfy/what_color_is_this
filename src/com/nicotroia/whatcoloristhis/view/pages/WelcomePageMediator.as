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
			
			//initCamera();
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
					var r:Rectangle = welcomePage.target.getBounds(contextView.stage);
					var fromX:uint = r.x;
					var fromY:uint = r.y;
					var toX:uint = r.x + r.width;
					var toY:uint = r.y + r.height;
					var posX:uint;
					var posY:uint;
					var color:uint;
					var hex:String;
					var bmd:BitmapData;
					
					trace("snap.");
					
					bmd = new BitmapData(_cameraRect.width, _cameraRect.height, false, 0);
					
					bmd.draw(_cameraView);
					
					var copy:BitmapData = new BitmapData(r.width, r.height, false, 0);
					
					if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
						
					}
					else { 
						fromY = r.y - layoutModel.navBarHeight;
						toY -= layoutModel.navBarHeight;
					}
					
					trace("target: " + r);
					trace("capturing: " + fromX, "to", toX, fromY, "to", toY);
					
					_capturedPixels = new Object();
					
					for( var currentX:uint = fromX; currentX < toX; currentX++ ) { 
						posX = Math.abs((toX - currentX) - uint(welcomePage.target.width));
						
						for( var currentY:uint = fromY; currentY < toY; currentY++ ) { 
							posY = Math.abs((toY - currentY) - uint(welcomePage.target.height));
							
							color = bmd.getPixel(currentX, currentY);
							hex = ColorHelper.colorToHexString(color);
							
							if( _capturedPixels[hex] ) { 
								_capturedPixels[hex]++;
							}
							else { 
								_capturedPixels[hex] = 1;
							}
							
							copy.setPixel(posX, posY, color);
							
							//trace(posX, posY, hex);
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
					
					cameraModel.saveImage(bmd);
					
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
			var targetSize:Number;
			
			if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
				welcomePage.actionBar.height = contextView.stage.stageHeight + 1;
				welcomePage.actionBar.width = 85;
				welcomePage.actionBar.x = contextView.stage.stageWidth - welcomePage.actionBar.width;
				welcomePage.actionBar.y = 0;
				
				targetSize = (contextView.stage.stageHeight - welcomePage.actionBar.width) * 0.42;
				photoButtonWidth = (contextView.stage.stageHeight * 0.3);
				
				welcomePage.takePhotoButton.width = photoButtonWidth;
				welcomePage.takePhotoButton.scaleY = welcomePage.takePhotoButton.scaleX;
				welcomePage.takePhotoButton.x = contextView.stage.stageWidth - welcomePage.takePhotoButton.width - 10;
				welcomePage.takePhotoButton.y = (contextView.stage.stageHeight * 0.5) - (welcomePage.takePhotoButton.height * 0.5);
				
				welcomePage.target.width = targetSize;
				welcomePage.target.scaleY = welcomePage.target.scaleX;
				welcomePage.target.x = ((contextView.stage.stageWidth - welcomePage.actionBar.width) * 0.5) - (welcomePage.target.width * 0.5);
				welcomePage.target.y = (contextView.stage.stageHeight * 0.5) - (welcomePage.target.height * 0.5);
				
				welcomePage.aboutPageButton.x = welcomePage.actionBar.x + 14;
				welcomePage.aboutPageButton.y = 14;
				
				if( _cameraView ) { 
					_cameraView.y = 0;
				}
			}
			else { 
				welcomePage.actionBar.height = 85;
				welcomePage.actionBar.width = contextView.stage.stageWidth + 1;
				welcomePage.actionBar.x = 0;
				welcomePage.actionBar.y = contextView.stage.stageHeight - welcomePage.actionBar.height;
				
				targetSize = (contextView.stage.stageWidth - welcomePage.actionBar.height - layoutModel.navBarHeight) * 0.42;
				photoButtonWidth = (contextView.stage.stageWidth * 0.3);
				
				welcomePage.takePhotoButton.width = photoButtonWidth;
				welcomePage.takePhotoButton.scaleY = welcomePage.takePhotoButton.scaleX;
				welcomePage.takePhotoButton.x = (contextView.stage.stageWidth * 0.5) - (welcomePage.takePhotoButton.width * 0.5);
				welcomePage.takePhotoButton.y = contextView.stage.stageHeight - welcomePage.takePhotoButton.height - 10;
				
				welcomePage.target.width = targetSize;
				welcomePage.target.scaleY = welcomePage.target.scaleX;
				welcomePage.target.x = (contextView.stage.stageWidth * 0.5) - (welcomePage.target.width * 0.5);
				welcomePage.target.y = layoutModel.navBarHeight + (((contextView.stage.stageHeight - welcomePage.actionBar.height - layoutModel.navBarHeight) * 0.5) - (welcomePage.target.height * 0.5));
				
				welcomePage.aboutPageButton.x = 14;
				welcomePage.aboutPageButton.y = welcomePage.actionBar.y + 14;
				
				if( _cameraView ) { 
					//push it down, I guess
					_cameraView.y = layoutModel.navBarHeight;
				}
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