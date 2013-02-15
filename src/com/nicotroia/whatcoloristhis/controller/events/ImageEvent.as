package com.nicotroia.whatcoloristhis.controller.events
{
	import flash.display.Bitmap;
	import flash.events.Event;

	public class ImageEvent extends Event
	{
		public static const CAMERA_ROLL_IMAGE_SELECTED:String = "CameraRollImageSelected";
		
		public var bitmap:Bitmap;
		
		public function ImageEvent(type:String, $bitmap:Bitmap, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			bitmap = $bitmap;
		}
	}
}