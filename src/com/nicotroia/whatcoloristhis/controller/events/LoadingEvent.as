package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.events.Event;

	public class LoadingEvent extends Event
	{
		public static var COLOR_RESULT_LOADING:String = "ColorResultLoading";
		public static var LOADING_FINISHED:String = "LoadingFinished";
		
		public function LoadingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
			
		}
	}
}