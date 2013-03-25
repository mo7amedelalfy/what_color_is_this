package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.events.Event;
	
	import starling.display.DisplayObject;

	public class NavigationEvent extends Event
	{
		public static const APP_START:String = "AppStart";
		public static const NAVIGATE_TO_PAGE:String = "NavigateToPage";
		public static const ADD_NAV_BUTTON_TO_HEADER_LEFT:String = "AddNavButtonToHeaderLeft";
		public static const ADD_NAV_BUTTON_TO_HEADER_RIGHT:String = "AddNavButtonToHeaderRight";
		public static const REMOVE_HEADER_NAV_BUTTONS:String = "RemoveHeaderNavButtons";
		
		public var pageConstant:Class;
		public var button:DisplayObject;
		
		public function NavigationEvent(type:String, _pageConstant:Class = null, _displayObject:DisplayObject = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			pageConstant = _pageConstant;
			button = _displayObject;
		}
	}
}