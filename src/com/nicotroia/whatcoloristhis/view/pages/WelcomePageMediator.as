package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.commands.GotoPageCommand;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import flash.display.Bitmap;
	
	import starling.display.Button;
	import starling.events.Event;

	public class WelcomePageMediator extends PageBaseMediator
	{
		[Inject]
		public var welcomePage:WelcomePage;
		
		[Inject(name="colorSpectrum")]
		public var colorSpectrum:Bitmap;
		
		override protected function pageAddedToStageHandler(event:Event=null):void
		{
			super.pageAddedToStageHandler(event);
			
			//trace("welcome page addedToStage");
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "What Color <i>Is</i> This?"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, welcomePage.settingsButton));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_RIGHT, null, welcomePage.aboutPageButton));
			
			eventMap.mapStarlingListener(welcomePage, Event.TRIGGERED, welcomePageTriggeredHandler);
			welcomePage.aboutPageButton.addEventListener(Event.TRIGGERED, aboutButtonTriggeredHandler);
			welcomePage.settingsButton.addEventListener(Event.TRIGGERED, settingsButtonTriggeredHandler);
			welcomePage.colorSpectrumButton.addEventListener(Event.TRIGGERED, colorSpectrumButtonTriggeredHandler);
		}
		
		private function colorSpectrumButtonTriggeredHandler(event:Event):void
		{
			cameraModel.initColorSpectrum(colorSpectrum);
		}
		
		private function aboutButtonTriggeredHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_About));
		}
		
		private function settingsButtonTriggeredHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Settings, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		private function welcomePageTriggeredHandler(event:Event):void
		{
			var buttonTriggered:Button = event.target as Button;
			
			//trace("welcome page triggered: " + buttonTriggered);
			
			if( buttonTriggered == welcomePage.takePhotoButton ) { 
				cameraModel.initCamera(); 
			}
			
			if( buttonTriggered == welcomePage.choosePhotoButton ) { 
				cameraModel.initCameraRoll();
			}
		}
		
		override public function onRemove():void
		{ 
			eventMap.unmapStarlingListener(welcomePage, Event.TRIGGERED, welcomePageTriggeredHandler);
			welcomePage.aboutPageButton.removeEventListener(Event.TRIGGERED, aboutButtonTriggeredHandler);
			welcomePage.settingsButton.removeEventListener(Event.TRIGGERED, settingsButtonTriggeredHandler);
			welcomePage.colorSpectrumButton.removeEventListener(Event.TRIGGERED, colorSpectrumButtonTriggeredHandler);
			
			trace("welcome page removing.");
			
			super.onRemove();
		}
		
	}
}