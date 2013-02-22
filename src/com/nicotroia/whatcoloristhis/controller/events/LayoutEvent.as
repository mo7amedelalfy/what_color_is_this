package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.events.Event;

	public class LayoutEvent extends Event
	{
		public static var UPDATE_LAYOUT:String = "UpdateLayout";
		/*public static var DEFAULT:String = "Default";
		public static var ROTATED_LEFT:String = "RotatedLeft";
		public static var ROTATED_RIGHT:String = "RotatedRight";
		public static var UPSIDE_DOWN:String = "UpsideDown";
		public static var UNKNOWN:String = "Unknown";*/
		
		public function LayoutEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
		}
	}
}