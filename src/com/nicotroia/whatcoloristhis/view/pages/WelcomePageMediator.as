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
	import flash.display.StageOrientation;
	import flash.events.StatusEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.text.TextField;
	
	import starling.display.Button;
	import starling.events.Event;

	public class WelcomePageMediator extends PageBaseMediator
	{
		[Inject]
		public var welcomePage:WelcomePage;
		
		//private var _camera:Camera;
		//private var _cameraView:Video;
		//private var _cameraRect:Rectangle;
		//private var _capturedPixels:Object;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			trace("welcome page registered");
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "What Color <i>Is</i> This?"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_RIGHT, null, welcomePage.settingsButton));
			
			eventMap.mapStarlingListener(welcomePage, Event.TRIGGERED, welcomePageTriggeredHandler);
			welcomePage.settingsButton.addEventListener(Event.TRIGGERED, settingsButtonTriggeredHandler);
		}
		
		private function settingsButtonTriggeredHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Settings));
		}
		
		private function welcomePageTriggeredHandler(event:Event):void
		{
			var buttonTriggered:Button = event.target as Button;
			
			trace("welcome page triggered: " + buttonTriggered);
			
			if( buttonTriggered == welcomePage.aboutPageButton ) { 
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_About));
			}
			
			if( buttonTriggered == welcomePage.takePhotoButton ) { 
				cameraModel.initCamera(); 
			}
		}
		
		override public function onRemove():void
		{
			eventMap.unmapStarlingListener(welcomePage, Event.TRIGGERED, welcomePageTriggeredHandler);
			welcomePage.settingsButton.removeEventListener(Event.TRIGGERED, settingsButtonTriggeredHandler);
			
			trace("welcome page removing.");
			
			super.onRemove();
		}
		
	}
}