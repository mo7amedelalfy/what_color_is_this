package com.nicotroia.whatcoloristhis.view.pages
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.ColorLinkedList;
	import com.nicotroia.whatcoloristhis.model.ColorNode;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import feathers.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
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
		private var _top5:ColorLinkedList; //Vector.<String>;

		private var _numberOfColorsToOrder:uint;
		
		override protected function pageAddedToStageHandler(event:Event=null):void
		{
			_target = areaSelectPage.vectorPage.target;
			_image = areaSelectPage.image;
			
			super.pageAddedToStageHandler(event);
			
			trace("area select page addedToStage");
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Select the area"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, areaSelectPage.backButton));
			
			eventMap.mapStarlingListener(areaSelectPage, Event.TRIGGERED, areaSelectPageTriggeredHandler);
			areaSelectPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			
			setTimeout( function():void { 
				areaSelectPage.drawCapturedImage(layoutModel, cameraModel);
				
				areaSelectPage.image.addEventListener(TouchEvent.TOUCH, imageTouchHandler);
			}, 1);
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
			if( contextView.stage.hasEventListener(Event.ENTER_FRAME) ) 
				contextView.stage.removeEventListener(Event.ENTER_FRAME, countPixelsOnEnterFrameHandler);
			
			_capturedPixels = new Object();
			_top5 = new ColorLinkedList();
			
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		private function areaSelectPageTriggeredHandler(event:Event):void
		{
			var buttonTriggered:DisplayObject = event.target as DisplayObject;
			
			trace("area select page triggered: " + buttonTriggered);
			
			if( buttonTriggered == areaSelectPage.acceptButton ) { 
				setTimeout( function():void { 
					acceptButtonClickHandler();
				}, 1);
			}
			
			if( buttonTriggered == areaSelectPage.cancelButton ) { 
				setTimeout( function():void { 
					cancelButtonClickHandler();
				}, 1);
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
			_top5 = new ColorLinkedList(); 
			
			//how do we redraw the scaled bitmap? or just apply the transformations?
			//var scaledBitmapData:BitmapData = areaSelectPage.drawScaledImage();
			
			//if we draw from a new scaled bitmap, we shouldn't get bounds based on the image, but the page instead.
			_targetRect = areaSelectPage.target.getBounds(areaSelectPage.image); 
			trace("target: " + _targetRect);
			
			//we should also copy pixels from the scaled bitmap... (keep it square)
			_targetCopy = new BitmapData(uint(_targetRect.width), uint(_targetRect.width), true, 0);
			_targetCopy.copyPixels(areaSelectPage.imageBitmap.bitmapData, _targetRect, new Point()); 
			
			_currentLoopNumber = 0;
			_totalLoops = _targetCopy.width * _targetCopy.height;
			
			//Fire up the engines...
			setTimeout( function():void { 
				contextView.stage.addEventListener(Event.ENTER_FRAME, countPixelsOnEnterFrameHandler);
			}, 1);
		}
		
		private function countPixelsOnEnterFrameHandler():void
		{
			if( _finishFlag ) { 
				contextView.stage.removeEventListener(Event.ENTER_FRAME, countPixelsOnEnterFrameHandler);
				
				cameraModel.top5 = _top5;
				cameraModel.targetedPixels = _targetCopy;
				
				var node:ColorNode = _top5.head;
				var rank:uint = 0;
				while( node ) { 
					trace(rank++ +": "+ node.data + " with " + _capturedPixels[node.data]);
					node = node.next;
				}
				
				eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_ConfirmColor));
				
				return;
			}
			
			//trace("start.");
			
			var color:uint;
			var hex:String;
			var loopsThisFrame:uint = 0;
			var currentNode:ColorNode;
			var currentNodeIndex:uint = 0;
			var winner:ColorNode;
			var fillerGap:uint = Math.floor(_totalLoops / 10); //add 10 spread-out fillers?
			var gapLeftUntilFiller:int = fillerGap;
			
			_startEnterFrameTime = getTimer();
			
			xLoop: for( _currentX; _currentX < _targetCopy.width; _currentX++ ) { 
				yLoop: for( _currentY; _currentY < _targetCopy.height; _currentY++ ) { 
					
					color = _targetCopy.getPixel32(_currentX, _currentY);
					
					//Ignore completely transparent (0x00000000) pixels
					if( color === 0 ) { 
						loopsThisFrame++;
						_currentLoopNumber++;
						continue;
					}
					
					//convert to string and remove transparency bits
					hex = color.toString(16);
					hex = hex.substr(2); 
					
					//increment the instances of this color
					_capturedPixels[hex] = (( _capturedPixels[hex] ) ? _capturedPixels[hex] + 1 : 1);
					
					//trace("PIXEL: "+ _currentX, ",", _currentY +" .... 0x"+ hex +", count: "+ _capturedPixels[hex]);
					
					currentNode = _top5.head;
					
					if( currentNode ) { 
						//Organize ColorNodes by rank
						while( currentNode ) { 
							
							//add the more used node above the lesser used node
							if( _capturedPixels[hex] > _capturedPixels[currentNode.data] || _top5.length < _numberOfColorsToOrder) { 
								
								//Use the existing colorNode, if possible
								winner = findColorNodeInList(hex); //already exists, remove it first
								
								if( winner == null ) { 
									winner = new ColorNode(hex); 
									
									//Or possibly add it just to fill up the list
									if( _top5.length < _numberOfColorsToOrder ) { 
										if( --gapLeftUntilFiller == 0 ) { 
											gapLeftUntilFiller = fillerGap;
											
											//trace(" adding filler color " + winner.data + "(" + _capturedPixels[winner.data] + ")");
											_top5.push( winner );
											
											break;
										}
									}
								}
								
								if( currentNode == _top5.head ) { 
									//Add the winner to head and push the rest
									//trace(" adding " + winner.data + "(" + _capturedPixels[winner.data] + ") to head");
									_top5.unshift(winner);
								}
								else { 
									//Add the winner in front of the loser
									//trace(" adding " + winner.data + "(" + _capturedPixels[winner.data] + ") before " + currentNode.data + "(" + _capturedPixels[currentNode.data] +")");
									_top5.addBefore(currentNode, winner);
								}
								
								//it's faster to not even do this?...
								///*
								if( _top5.length > _numberOfColorsToOrder ) { 
									//keep it under control
									_top5.pop();
									//trace("POP! length: " + _top5.length);
									//_top5.iterate();
								}
								//*/
								
								//all sorted, continue to the next pixel
								break;
							}
							
							currentNodeIndex++;
							currentNode = currentNode.next;
							
							//Only compare color to the top ranked spots
							if( currentNodeIndex > _numberOfColorsToOrder ) { 
								break;
							}
						}
					}
					else { 
						_top5.push( new ColorNode(hex) );
						//trace(" pushed the very first head: " + hex + "(" + _capturedPixels[hex] + ")");
					}
					
					loopsThisFrame++;
					_currentLoopNumber++;
					
					//Check for completion
					if( _currentLoopNumber >= _totalLoops ) { 
						//done
						_finishFlag = true;
						
						break xLoop;
					}
					
					if( (getTimer() - _startEnterFrameTime) > _maxEnterFrameTime ) { 
						//that's enough for now...
						break xLoop;
					}
				}
				
				_currentY = 0;
			}
			
			//Just to make sure we didnt skip empty pixels didn't perform a check
			if( _currentLoopNumber >= _totalLoops ) { 
				//done
				_finishFlag = true;
			}
			
			trace(" end. " + _currentLoopNumber + "/" + _totalLoops + " px. " + loopsThisFrame + " loops in " + (getTimer() - _startEnterFrameTime) + "ms");
		}
		
		private function findColorNodeInList(hex:String):ColorNode
		{
			var current:ColorNode = _top5.head;
			
			while( current ) { 
				if( current.data == hex ) { 
					//trace("found it.");
					return _top5.remove(current);
				}
				
				current = current.next;
			}
			
			return null;
		}
		
		private function cancelButtonClickHandler():void
		{
			trace("cancel");
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		override public function onRemove():void
		{
			if( contextView.stage.hasEventListener(Event.ENTER_FRAME) ) 
				contextView.stage.removeEventListener(Event.ENTER_FRAME, countPixelsOnEnterFrameHandler);
			
			eventMap.unmapStarlingListener(areaSelectPage, Event.TRIGGERED, areaSelectPageTriggeredHandler);
			areaSelectPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			areaSelectPage.image.removeEventListener(TouchEvent.TOUCH, imageTouchHandler);
			
			trace("areaSelectPage removed");
			
			_capturedPixels = null;
			
			super.onRemove();
		}
	}
}