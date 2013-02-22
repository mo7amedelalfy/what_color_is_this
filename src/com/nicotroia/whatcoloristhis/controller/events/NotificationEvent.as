package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.events.Event;

	public class NotificationEvent extends Event
	{
		public static const CHANGE_TOP_NAV_BAR_TITLE:String = "ChangeTopNavBarTitle";
		
		public var text:String;
		
		public function NotificationEvent(type:String, $text:String = '', bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			text = $text;
		}
	}
}