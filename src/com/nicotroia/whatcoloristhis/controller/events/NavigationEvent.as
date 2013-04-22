package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.events.Event;
	
	import starling.display.DisplayObject;

	public class NavigationEvent extends Event
	{
		public static const APP_START:String = "AppStart";
		public static const NAVIGATE_TO_PAGE:String = "NavigateToPage";
		public static const NAVIGATE_RIGHT:String = "NavigateRight";
		public static const NAVIGATE_LEFT:String = "NavigateLeft";
		public static const ADD_NAV_BUTTON_TO_HEADER_LEFT:String = "AddNavButtonToHeaderLeft";
		public static const ADD_NAV_BUTTON_TO_HEADER_RIGHT:String = "AddNavButtonToHeaderRight";
		public static const REMOVE_HEADER_NAV_BUTTONS:String = "RemoveHeaderNavButtons";
		public static const SETTINGS_PAGE_CONFIRMED:String = "SettingsPageConfirmed";
		
		public var pageConstant:Class;
		public var button:DisplayObject;
		public var direction:String;
		
		public function NavigationEvent(type:String, _pageConstant:Class = null, _displayObjectToAdd:DisplayObject = null, _direction:String = NAVIGATE_RIGHT, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			pageConstant = _pageConstant;
			button = _displayObjectToAdd;
			direction = _direction;
		}
	}
}