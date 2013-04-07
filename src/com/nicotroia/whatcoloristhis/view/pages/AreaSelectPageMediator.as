package com.nicotroia.whatcoloristhis.view.pages
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.controller.utils.ColorHelper;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import feathers.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class AreaSelectPageMediator extends PageBaseMediator
	{
		[Inject]
		public var areaSelectPage:AreaSelectPage;
		
		private var _target:Target;
		private var _image:Image;
		private var _capturedPixels:Object;
		
		private var _startEnterFrameTime:Number = 0.0;
		private var _maxEnterFrameTime:Number = 12.0;
		private var _currentLoopNumber:uint = 0;
		private var _totalLoops:uint = 0;
		private var _finishFlag:Boolean;
		
		private var _currentTouchPhase:String;
		private var _targetRect:Rectangle;
		private var _targetCopy:BitmapData;
		private var _imageScale:Number;
		private var _oldLocalPoint:Point;
		private var _newLocalPoint:Point;
		private var _isTransitioning:Boolean;
		private var _currentX:uint;
		private var _currentY:uint;
		private var _top5:Array;

		private var _numberOfColorsToOrder:uint;
		
		override public function onRegister():void
		{
			_target = areaSelectPage.vectorPage.target;
			_image = areaSelectPage.image;
			
			super.onRegister();
			
			trace("area select page registered");
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Select the area"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, areaSelectPage.backButton));
			
			areaSelectPage.drawCapturedImage(layoutModel, cameraModel);
			
			eventMap.mapStarlingListener(areaSelectPage, Event.TRIGGERED, areaSelectPageTriggeredHandler);
			areaSelectPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			areaSelectPage.image.addEventListener(TouchEvent.TOUCH, imageTouchHandler);
		}
		
		private function imageTouchHandler(event:TouchEvent):void
		{
			var targetImage:Image = event.target as Image;
			var touches:Vector.<Touch> = event.getTouches(contextView.stage, TouchPhase.MOVED);
			var touch:Touch;
			
			//thank you Starling TouchSheet
			if( touches.length == 1 ) { 
				// one finger touching == move
				var delta:Point = touches[0].getMovement(targetImage.parent);
				
				targetImage.x += delta.x;
				targetImage.y += delta.y;
			}
			else if( touches.length == 2 ) { 
				//two finger touching == rotate and scale
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				
				_oldLocalPoint = touchA.getLocation(targetImage);
				
				var currentPosA:Point  = touchA.getLocation(targetImage.parent); //areaSelectPage);
				var previousPosA:Point = touchA.getPreviousLocation(targetImage.parent);
				var currentPosB:Point  = touchB.getLocation(targetImage.parent);
				var previousPosB:Point = touchB.getPreviousLocation(targetImage.parent); 
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
				var deltaAngle:Number = currentAngle - previousAngle;
				
				// update pivot point based on previous center
				var previousLocalA:Point  = touchA.getPreviousLocation(targetImage);
				var previousLocalB:Point  = touchB.getPreviousLocation(targetImage);
				targetImage.pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
				targetImage.pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
				
				// update location based on the current center
				targetImage.x = (currentPosA.x + currentPosB.x) * 0.5;
				targetImage.y = (currentPosA.y + currentPosB.y) * 0.5;
				
				// rotate
				//targetImage.rotation += deltaAngle;
				
				// scale
				var sizeDiff:Number = currentVector.length / previousVector.length;
				
				targetImage.scaleX *= sizeDiff;
				targetImage.scaleY *= sizeDiff;
				
				//for below
				_imageScale = targetImage.scaleX;
			}
			
			touch = event.getTouch(targetImage, TouchPhase.ENDED);
			if( touch && touch.tapCount == 2 ) {
				//Two taps == scale around point
				
				if( _isTransitioning || (_imageScale && _imageScale == 5.0) ) return;
				
				var globalTouch:Point = touch.getLocation(targetImage.parent);
				var localTouch:Point = touch.getLocation(targetImage);
				
				targetImage.pivotX = localTouch.x;
				targetImage.pivotY = localTouch.y;
				
				//Set the target scale
				_imageScale = (_imageScale) ? (_imageScale * 1.5) : 1.5;
				if( _imageScale > 5.0 ) _imageScale = 5.0;
				
				//Move the image back to where it was before we changed the pivot
				targetImage.x = globalTouch.x; 
				targetImage.y = globalTouch.y; 

				//Scaling the image will now pivot, thanks Starling
				_isTransitioning = true;
				TweenLite.to(targetImage, 0.25, {scaleX:_imageScale, scaleY:_imageScale, ease:Expo.easeInOut, onComplete:function():void { 
					_isTransitioning = false;
					//trace(targetImage.scaleX, targetImage.width, targetImage.height);
				}});
			}
			
			//Don't get too crazy now...
			if( targetImage.scaleX < 0.9 ) { 
				targetImage.scaleX = targetImage.scaleY = 0.9;
			}
			
			if( targetImage.scaleX > 5.0 ) { 
				targetImage.scaleX = targetImage.scaleY = 5.0;
			}
		}
		
		private function backButtonTriggeredHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		private function areaSelectPageTriggeredHandler(event:Event):void
		{
			var buttonTriggered:DisplayObject = event.target as DisplayObject;
			
			trace("area select page triggered: " + buttonTriggered);
			
			if( buttonTriggered == areaSelectPage.acceptButton ) { 
				acceptButtonClickHandler();
			}
			
			if( buttonTriggered == areaSelectPage.cancelButton ) { 
				cancelButtonClickHandler();
			}
		}
		
		private function acceptButtonClickHandler():void
		{
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, "Counting pixels..."));
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.COUNTING_PIXELS));
			
			//Set up variables
			
			_numberOfColorsToOrder = Settings.colorChoicesGivenToUser;
			_capturedPixels = new Object();
			_finishFlag = false;
			_currentX = 0;
			_currentY = 0;
			_top5 = [];
			
			//how do we redraw the scaled bitmap? or just apply the transformations?
			//var scaledBitmapData:BitmapData = areaSelectPage.drawScaledImage();
			
			//if we draw from a new scaled bitmap, we shouldn't get bounds based on the image, but the page instead.
			_targetRect = areaSelectPage.target.getBounds(areaSelectPage.image); 
			trace("target: " + _targetRect);
			
			//we should also copy pixels from the scaled bitmap...
			_targetCopy = new BitmapData(uint(_targetRect.width), uint(_targetRect.height), true, 0);
			_targetCopy.copyPixels(areaSelectPage.imageBitmap.bitmapData, _targetRect, new Point()); 
			
			_totalLoops = _targetCopy.width;
			
			//Fire up the engines...
			contextView.stage.addEventListener(Event.ENTER_FRAME, countPixelsOnEnterFrameHandler);
		}
		
		private function countPixelsOnEnterFrameHandler():void
		{
			if( _finishFlag ) { 
				contextView.stage.removeEventListener(Event.ENTER_FRAME, countPixelsOnEnterFrameHandler);
				
				cameraModel.top5 = _top5;
				cameraModel.targetedPixels = _targetCopy;
				
				//if iOS only... i think.
				//cameraModel.saveImage(bmd);
				
				eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_ConfirmColor));
				
				return;
			}
			
			trace("start.");
			
			var color:uint;
			var hex:String;
			var loopsThisFrame:uint = 0;
			
			_startEnterFrameTime = getTimer();
			
			for( _currentX; _currentX < _targetCopy.width; _currentX++ ) { 
				for( _currentY; _currentY < _targetCopy.height; _currentY++ ) { 
					
					color = _targetCopy.getPixel(_currentX, _currentY);
					
					if( color === 0 ) continue;
					
					hex = ColorHelper.colorToHexString(color);
					
					_capturedPixels[hex] = (( _capturedPixels[hex] ) ? _capturedPixels[hex] + 1 : 1);
					
					//trace("PIXEL: "+ currentX, ",", currentY +" .... 0x"+ hex +", count: "+ _capturedPixels[hex]);
					
					//Add current color to top5 where it belongs
					
					if( _top5.length == _numberOfColorsToOrder ) { 
						for( var rank:int = 0; rank < _numberOfColorsToOrder; rank++ ) { 
							//trace("top5 #"+ rank +" is " + top5[rank]);
							
							if( _capturedPixels[hex] > _capturedPixels[_top5[rank]] ) { 
								var loserHex:String = _top5[rank];
								
								//remove the loser
								_top5.splice(rank, 1);
								
								//add the winner at loser's old position
								_top5.splice(rank, 0, hex);
								
								//add the loser back at rank+1
								_top5.splice(rank + 1, 0, loserHex);
								
								//remove any winner duplicates, since it's most likely already on the list
								var foundDupe:Boolean = false;
								for( var testRank:uint = 0; testRank < _numberOfColorsToOrder; testRank++ ) { 
									if( rank != testRank && _top5[testRank] == hex ) { 
										_top5.splice(testRank, 1);
										foundDupe = true;
									}
								}
								
								if( ! foundDupe ) { 
									//or, since all items are unique, just pop() to keep 5 only
									_top5.pop();
								}
								
								break;
							}	
						}
					}
					else { 
						_top5[_top5.length] = hex;
					}
				}
				
				loopsThisFrame++;
				_currentLoopNumber++;
				//trace("currentLoopNumber: " + _currentLoopNumber + "/" + _totalLoops + ", currentTime: " + (getTimer() - _startEnterFrameTime));
				
				if( _currentLoopNumber == _totalLoops ) { 
					//done
					_finishFlag = true;
					
					for( rank = 0; rank < _numberOfColorsToOrder; rank++ ) { 
						trace(rank +": "+ _top5[rank] + " with " + _capturedPixels[_top5[rank]]);
					}
					
					break;
				}
				
				if( (getTimer() - _startEnterFrameTime) > _maxEnterFrameTime ) { 
					//that's enough for now...
					break;
				}
				
			}
			
			trace(" end. " + loopsThisFrame + "/" + _totalLoops + " px took: " + (getTimer() - _startEnterFrameTime) + "ms");
		}
		
		private function cancelButtonClickHandler():void
		{
			trace("cancel");
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		override public function onRemove():void
		{
			eventMap.unmapStarlingListener(areaSelectPage, Event.TRIGGERED, areaSelectPageTriggeredHandler);
			areaSelectPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			areaSelectPage.image.removeEventListener(TouchEvent.TOUCH, imageTouchHandler);
			
			trace("areaSelectPage removed");
			
			_capturedPixels = null;
			
			super.onRemove();
		}
	}
}