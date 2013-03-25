package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.events.Event;
	
	public class LayoutEvent extends Event
	{
		public static var RESIZE:String = "Resize";
		public static var ORIENTATION_CHANGE:String = "OrientationChange";
		public static var UPDATE_LAYOUT:String = "UpdateLayout";
		public static var PAGE_ADDED_TO_STAGE:String = "PageAddedToStage";
		
		public function LayoutEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
		}
	}
}