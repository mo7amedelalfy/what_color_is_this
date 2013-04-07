package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.events.Event;

	public class LoadingEvent extends Event
	{
		public static var PAGE_LOADING:String = "PageLoading";
		public static var CAMERA_LOADING:String = "CameraLoading";
		public static var CAMERA_ROLL_LOADING:String = "CameraRollLoading";
		public static var COUNTING_PIXELS:String = "CountingPixels";
		public static var COLOR_RESULT_LOADING:String = "ColorResultLoading";
		public static var LOADING_FINISHED:String = "LoadingFinished";
		
		public function LoadingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
			
		}
	}
}