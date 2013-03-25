package com.nicotroia.whatcoloristhis.view.overlays
{
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.view.pages.PageBaseMediator;
	
	import starling.events.Event;
	
	public class HeaderOverlayMediator extends PageBaseMediator
	{
		[Inject]
		public var headerOverlay:HeaderOverlay;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(eventDispatcher, NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, changeTopNavBarTitleHandler);
			eventMap.mapListener(eventDispatcher, NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, addButtonToHeaderLeftHandler);
			eventMap.mapListener(eventDispatcher, NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_RIGHT, addButtonToHeaderRightHandler);
			eventMap.mapListener(eventDispatcher, NavigationEvent.REMOVE_HEADER_NAV_BUTTONS, removeHeaderNavButtonsHandler);
			
			//eventMap.mapListener(headerOverlay.header, Event.TRIGGERED, headerOverlayTriggeredHandler);
		}
		
		private function removeHeaderNavButtonsHandler(event:NavigationEvent):void
		{
			headerOverlay.removeButtons();
		}
		
		private function headerOverlayTriggeredHandler(event:Event):void
		{
			trace("header overlay triggerd handler");
		}
		
		private function addButtonToHeaderLeftHandler(event:NavigationEvent):void
		{
			headerOverlay.addButtonToLeft(event.button);
		}
		
		private function addButtonToHeaderRightHandler(event:NavigationEvent):void
		{
			headerOverlay.addButtonToRight(event.button);
		}
		
		private function changeTopNavBarTitleHandler(event:NotificationEvent):void
		{
			headerOverlay.changeTitle(event.text);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			eventMap.unmapListener(eventDispatcher, NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, changeTopNavBarTitleHandler);
			eventMap.unmapListener(eventDispatcher, NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, addButtonToHeaderLeftHandler);
			eventMap.unmapListener(eventDispatcher, NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_RIGHT, addButtonToHeaderRightHandler);
			eventMap.unmapListener(eventDispatcher, NavigationEvent.NAVIGATE_TO_PAGE, removeHeaderNavButtonsHandler);
		}
	}
}