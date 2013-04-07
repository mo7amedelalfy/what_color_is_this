package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import feathers.controls.Button;
	
	import starling.events.Event;

	public class AboutPageMediator extends PageBaseMediator
	{
		[Inject]
		public var aboutPage:AboutPage;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			trace("about page registered");
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, aboutPage.backButton));
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "About"));
			
			//eventMap.mapStarlingListener(aboutPage, Event.TRIGGERED, aboutPageTriggeredHandler); 
			aboutPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
		}
		
		private function backButtonTriggeredHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		private function aboutPageTriggeredHandler(event:Event):void
		{
			var feathersButton:Button = event.target as Button;
			
		}
		
		override public function onRemove():void
		{
			//eventMap.unmapStarlingListener(aboutPage, Event.TRIGGERED, aboutPageTriggeredHandler); 
			aboutPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			
			super.onRemove();
			
			trace("about page onRemove");
		}
	}
}