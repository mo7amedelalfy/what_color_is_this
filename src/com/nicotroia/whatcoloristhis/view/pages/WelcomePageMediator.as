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
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.text.TextField;
	import flash.utils.Timer;

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
		private var _stageVideo:StageVideo;
		private var _stageVideoAvailable:Boolean;
		private var _timer:Timer = new Timer(1000);
		private var _tf:TextField;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(welcomePage.takePhotoButton, MouseEvent.CLICK, takePhotoButtonClickHandler);
			
			contextView.stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, stageVideoAvailabilityHandler, false, 0, true);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "What Color <i>Is</i> This?"));
		}
		
		protected function stageVideoAvailabilityHandler(event:StageVideoAvailabilityEvent):void
		{
			trace("STAGE VIDEO " + event.availability);
			
			if( event.availability == StageVideoAvailability.AVAILABLE ) { 
				_stageVideo = contextView.stage.stageVideos[0];
				_stageVideoAvailable = true;
			}
			
			setupCamera();
		}
		
		private function setupCamera():void
		{
			trace("setup camera");
			
			_tf = new TextField();
			_tf.x = 14;
			_tf.y = 14;
			
			if( Camera.isSupported ) { 
				_camera = Camera.getCamera();
				
				if( ! _camera ) { 
					//camera in use or disabled
					//display oops
					
					_tf.text = "No camera is installed.";
				}
				else if( _camera.muted ) { 
					//user denied the application access to camera
					//display oops
					
					_tf.text = "To enable the use of the camera,\n"
						+ "please click on the camera button.\n" 
						+ "When the Flash Player Settings dialog appears,\n"
						+ "make sure to select the Allow radio button\n" 
						+ "to grant access to your camera.";
				}
				else { 
					_tf.text = "Connecting...";
					
					connectCamera();
				}
				
				welcomePage.addChild(_tf);
				
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			}
			else { 
				//no camera on this device
				//display oops 
			}
		}
		
		private function takePhotoButtonClickHandler(event:MouseEvent):void
		{
			if( _camera ) { 
				if( _camera.muted ) { 
					//display application permissions dialog
					Security.showSettings(SecurityPanel.PRIVACY);
					
					_camera.addEventListener(StatusEvent.STATUS, permissionStatusHandler);
				}
				else { 
					var bmd:BitmapData;
					
					trace("snap.");
					
					if( _stageVideoAvailable ) { 
						bmd = new BitmapData(_cameraRect.width, _cameraRect.height);
						
						//?
						//bmd.draw(_stageVideo);
					}
					else { 
						bmd = new BitmapData(_cameraView.width, _cameraView.height, false, 0);
						
						bmd.draw(_cameraView);
						
						var r:Rectangle = welcomePage.target.getBounds(contextView.stage);
						var x:uint = r.x;
						var y:uint = r.y;
						var toX:uint = x + Math.floor( welcomePage.target.width );
						var toY:uint = y + Math.floor( welcomePage.target.height );
						var color:uint;
						var hex:String;
						
						_capturedPixels = new Object();
						
						for( x; x < toX; x++ ) { 
							for( y; y < toY; y++ ) { 
								color = bmd.getPixel(x,y);
								hex = ColorHelper.colorToHexString(color);
								
								if( _capturedPixels[hex] ) { 
									_capturedPixels[hex]++;
								}
								else { 
									_capturedPixels[hex] = 1;
								}
								
								trace(hex, _capturedPixels[hex]);
								//trace("x: " + x, "y: "+ y + " color: 0x" + ColorHelper.colorToHexString(color) );
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
						
						eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Result));
					}
				}
			}
		}
		
		protected function permissionStatusHandler(event:StatusEvent):void
		{
			if(event.code == "Camera.Unmuted") {
				_camera.removeEventListener(StatusEvent.STATUS, permissionStatusHandler);
				
				connectCamera(); 
			}
		}
		
		private function connectCamera():void
		{
			if( contextView.stage.stageWidth > contextView.stage.stageHeight ) { 
				_cameraRect = new Rectangle(0, 0, contextView.stage.stageWidth, contextView.stage.stageHeight);
			}
			else { 
				_cameraRect = new Rectangle(0, layoutModel.navBarHeight, contextView.stage.stageHeight, contextView.stage.stageWidth);
			}
			
			if( _stageVideoAvailable ) { 
				trace("using stageVideo!");
				_stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, onRenderState);
				_stageVideo.attachCamera(_camera);
			}
			else { 
				trace("using regular video");
				_cameraView = new Video(_cameraRect.width, _cameraRect.height);
				_cameraView.x = _cameraRect.x;
				_cameraView.y = _cameraRect.y;			
				
				_cameraView.attachCamera(_camera);
				
				_cameraView.addEventListener(MouseEvent.CLICK, cameraViewClickHandler, false, 0, true);
				
				welcomePage.addChildAt(_cameraView, 0);
			}
			
			_camera.setMode(_cameraRect.width, _cameraRect.height, 15); 
			
			_timer.start();
		}
		
		protected function cameraViewClickHandler(event:MouseEvent):void
		{
			trace("focusing.");
			_camera.setMode(_cameraRect.width, _cameraRect.height, 15); 
		}
		
		private function onRenderState(e:StageVideoEvent):void {
			_stageVideo.viewPort = new Rectangle(0, 0, contextView.stage.stageWidth, contextView.stage.stageHeight);
		}
		
		private function timerHandler(event:TimerEvent):void 
		{
			_tf.text = "";
			_tf.appendText("fps: " + Math.round(_camera.currentFPS) + "\n");
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
					_cameraView.y = layoutModel.navBarHeight;
				}
			}
			
			//trace(targetSize);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			trace("welcome page removing.");
			
			contextView.stage.removeEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, stageVideoAvailabilityHandler);
			_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			
			if( welcomePage.contains(_tf) ) welcomePage.removeChild(_tf);
			
			if( _stageVideoAvailable ) { 
				if( _stageVideo ) _stageVideo.attachCamera(null);
			}
			else if( _cameraView ) { 
				_cameraView.attachCamera(null);
				welcomePage.removeChild(_cameraView);
			}
			
			_camera = null;
			_cameraView = null;
		}
		
	}
}