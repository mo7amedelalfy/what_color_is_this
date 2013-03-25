package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.controller.utils.ColorHelper;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import feathers.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageOrientation;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;

	public class AreaSelectPageMediator extends PageBaseMediator
	{
		[Inject]
		public var areaSelectPage:AreaSelectPage;
		
		private var _target:Target;
		private var _image:Image;
		private var _capturedPixels:Object;
		private var _userMovedPhoto:Boolean;
		
		override public function onRegister():void
		{
			_target = areaSelectPage.vectorPage.target;
			_image = areaSelectPage.image;
			
			super.onRegister();
			
			trace("area select page registered");
			
			//areaSelectPage.addChildAt(_image, 0);
			//areaSelectPage.addChildAt(_target, 1);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Select the area"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, areaSelectPage.backButton));
			
			areaSelectPage.drawCapturedImage(layoutModel, cameraModel);
			
			eventMap.mapStarlingListener(areaSelectPage, Event.TRIGGERED, areaSelectPageTriggeredHandler);
			areaSelectPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
		}
		
		private function backButtonTriggeredHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
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
			var r:Rectangle = areaSelectPage.target.getBounds(areaSelectPage.image); 
			var copy:BitmapData = new BitmapData(uint(r.width), uint(r.height), false, 0);
			var color:uint;
			var hex:String;
			var top5:Array = [];
			
			trace("snap.");
			trace("target: " + r);
			
			_capturedPixels = new Object();
			copy.copyPixels(areaSelectPage.imageBitmap.bitmapData, r, new Point());
			
			//if we copy outside the bounds of the image, how can the fill be transparent?
			
			var before:uint;
			
			before = getTimer();
			
			for( var currentX:uint = 0; currentX < uint(r.width); currentX++ ) { 
				for( var currentY:uint = 0; currentY < uint(r.height); currentY++ ) { 
					
					color = copy.getPixel(currentX, currentY);
					
					if( color === 0 ) continue;
					
					hex = ColorHelper.colorToHexString(color);
					
					_capturedPixels[hex] = (( _capturedPixels[hex] ) ? _capturedPixels[hex] + 1 : 1);
					
					//trace("PIXEL: "+ currentX, ",", currentY +" .... 0x"+ hex +", count: "+ _capturedPixels[hex]);
					
					//rank 1-5, hex, count
					if( top5.length == 5 ) { 
						//we will check in reverse to deal with doubles
						for( var rank:int = 0; rank < 5; rank++ ) { 
							//trace("top5 #"+ rank +" is " + top5[rank]);
							
							if( _capturedPixels[hex] > _capturedPixels[top5[rank]] ) { 
								//trace(hex +"("+ _capturedPixels[hex] +") > rank "+ rank +": "+ top5[rank] +"("+ _capturedPixels[top5[rank]] +")");
								
								var loserHex:String = top5[rank];
								
								//remove the loser
								top5.splice(rank, 1);
								
								//add the winner at loser's old position
								top5.splice(rank, 0, hex);
								
								//add the loser back at rank+1
								top5.splice(rank + 1, 0, loserHex);
								
								//remove any winner duplicates, since it's most likely already on the list
								if( rank != 0 && top5[0] == hex ) { 
									top5.splice(0, 1);
								}
								else if( rank != 1 && top5[1] == hex ) { 
									top5.splice(1, 1);
								}
								else if( rank != 2 && top5[2] == hex ) { 
									top5.splice(2, 1);
								}
								else if( rank != 3 && top5[3] == hex ) { 
									top5.splice(3, 1);
								}
								else if( rank != 4 && top5[4] == hex ) { 
									top5.splice(4, 1);
								}
								else { 
									//or, since all items are unique, just pop() to keep 5 only
									top5.pop();
								}
								
								break;
							}	
						}
					}
					else { 
						top5[top5.length] = hex;
					}
				}
			}
			
			trace("--------------- counting and sorting took: " + (getTimer() - before) +"ms");
			
			trace("0: " + top5[0] + " with " + _capturedPixels[top5[0]]);
			trace("1: " + top5[1] + " with " + _capturedPixels[top5[1]]);
			trace("2: " + top5[2] + " with " + _capturedPixels[top5[2]]);
			trace("3: " + top5[3] + " with " + _capturedPixels[top5[3]]);
			trace("4: " + top5[4] + " with " + _capturedPixels[top5[4]]);
			
			cameraModel.top5 = top5;
			//cameraModel.winnerHex = top5[0];
			cameraModel.targetedPixels = copy;
			
			//if iOS only... i think.
			//cameraModel.saveImage(bmd);
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_ConfirmColor));
		}
		
		private function cancelButtonClickHandler():void
		{
			trace("cancel");
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
		
		override public function onRemove():void
		{
			eventMap.unmapStarlingListener(areaSelectPage, Event.TRIGGERED, areaSelectPageTriggeredHandler);
			areaSelectPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			
			trace("areaSelectPage removed");
			
			super.onRemove();
		}
	}
}