package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import starling.display.Button;
	import starling.events.Event;

	public class WelcomePageMediator extends PageBaseMediator
	{
		[Inject]
		public var welcomePage:WelcomePage;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			trace("welcome page registered");
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "What Color <i>Is</i> This?"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_RIGHT, null, welcomePage.settingsButton));
			
			eventMap.mapStarlingListener(welcomePage, Event.TRIGGERED, welcomePageTriggeredHandler);
			welcomePage.settingsButton.addEventListener(Event.TRIGGERED, settingsButtonTriggeredHandler);
			welcomePage.choosePhotoButton.addEventListener(Event.TRIGGERED, choosePhotoButtonTriggeredHandler);
		}
		
		private function settingsButtonTriggeredHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Settings));
		}
		
		private function choosePhotoButtonTriggeredHandler(event:Event):void
		{
			cameraModel.initCameraRoll();
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
			welcomePage.choosePhotoButton.removeEventListener(Event.TRIGGERED, choosePhotoButtonTriggeredHandler);
			
			trace("welcome page removing.");
			
			super.onRemove();
		}
		
	}
}