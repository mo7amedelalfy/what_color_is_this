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
		
		override public function onRegister():void
		{
			super.onRegister();
			
			trace("settings page registered");
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Settings"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, settingsPage.backButton));
			
			eventMap.mapStarlingListener(settingsPage, Event.TRIGGERED, settingsPageTriggeredHandler); 
			settingsPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			settingsPage.fetchCrayolaToggle.addEventListener(Event.CHANGE, fetchCrayolaToggleChangeHandler);
			settingsPage.fetchPantoneToggle.addEventListener(Event.CHANGE, fetchPantoneToggleChangeHandler);
		}
		
		private function fetchPantoneToggleChangeHandler(event:Event):void
		{
			Settings.fetchPantoneResults = settingsPage.fetchPantoneToggle.isSelected;
		}
		
		private function fetchCrayolaToggleChangeHandler(event:Event):void
		{
			Settings.fetchCrayolaResults = settingsPage.fetchCrayolaToggle.isSelected;
		}
		
		private function backButtonTriggeredHandler():void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
		
		private function settingsPageTriggeredHandler(event:Event):void
		{
			// TODO Auto Generated method stub
			
		}
		
		override public function onRemove():void
		{
			trace("settings page removed");
			
			eventMap.unmapStarlingListener(settingsPage, Event.TRIGGERED, settingsPageTriggeredHandler); 
			settingsPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			
			super.onRemove();
			
		}
	}
}