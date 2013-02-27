package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.events.Event;

	public class CameraEvent extends Event
	{
		public static const CAMERA_IMAGE_TAKEN:String = "CameraImageTaken";
		public static const CAMERA_IMAGE_FAILED:String = "CameraImageFailed";
		public static const CAMERA_ROLL_IMAGE_SELECTED:String = "CameraRollImageSelected";
		public static const CAMERA_ROLL_IMAGE_FAILED:String = "CameraRollImageFailed";
		
		public function CameraEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}