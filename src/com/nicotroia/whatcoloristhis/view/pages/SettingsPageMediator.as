package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import starling.events.Event;

	public class SettingsPageMediator extends PageBaseMediator
	{
		[Inject]
		public var settingsPage:SettingsPage;
		
		override protected function pageAddedToStageHandler(event:Event = null):void
		{
			super.pageAddedToStageHandler(event);
			
			//trace("settings page addedToStage");
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Settings"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, settingsPage.backButton));
			
			settingsPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			settingsPage.fetchNtcToggle.addEventListener(Event.CHANGE, fetchNtcToggleChangeHandler);
			settingsPage.fetchCrayolaToggle.addEventListener(Event.CHANGE, fetchCrayolaToggleChangeHandler);
			settingsPage.fetchPantoneToggle.addEventListener(Event.CHANGE, fetchPantoneToggleChangeHandler);
			settingsPage.numberOfChoicesSlider.addEventListener(Event.CHANGE, numberOfChoicesSliderChangeHandler);
		}
		
		private function numberOfChoicesSliderChangeHandler(event:Event):void
		{
			Settings.colorChoicesGivenToUser = settingsPage.numberOfChoicesSlider.value;
		}
		
		private function fetchNtcToggleChangeHandler(event:Event):void
		{
			Settings.fetchNtcResults = settingsPage.fetchNtcToggle.isSelected;
		}
		
		private function fetchCrayolaToggleChangeHandler(event:Event):void
		{
			Settings.fetchCrayolaResults = settingsPage.fetchCrayolaToggle.isSelected;
		}
		
		private function fetchPantoneToggleChangeHandler(event:Event):void
		{
			Settings.fetchPantoneResults = settingsPage.fetchPantoneToggle.isSelected;
		}
		
		private function backButtonTriggeredHandler():void
		{
			//will trigger SaveSettingsCommand
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.SETTINGS_PAGE_CONFIRMED ));
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_RIGHT));
		}
		
		override public function onRemove():void
		{
			trace("settings page removed");
			
			settingsPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			settingsPage.fetchNtcToggle.removeEventListener(Event.CHANGE, fetchNtcToggleChangeHandler);
			settingsPage.fetchCrayolaToggle.removeEventListener(Event.CHANGE, fetchCrayolaToggleChangeHandler);
			settingsPage.fetchPantoneToggle.removeEventListener(Event.CHANGE, fetchPantoneToggleChangeHandler);
			settingsPage.numberOfChoicesSlider.removeEventListener(Event.CHANGE, numberOfChoicesSliderChangeHandler);
			
			super.onRemove();
			
		}
	}
}