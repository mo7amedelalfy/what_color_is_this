package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.events.Event;

	public class NavigationEvent extends Event
	{
		public static const APP_START:String = "AppStart";
		public static const NAVIGATE_TO_PAGE:String = "NavigateToPage";
		
		public var pageConstant:Class;
		
		public function NavigationEvent(type:String, _pageConstant:Class = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			pageConstant = _pageConstant;
		}
	}
}