package com.nicotroia.whatcoloristhis.view.buttons
{
	import flash.events.MouseEvent;

	public class TakePhotoButtonMediator extends ButtonBaseMediator
	{
		[Inject]
		public var takePhotoButton:TakePhotoButton;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(takePhotoButton, MouseEvent.CLICK, takePhotoButtonClickHandler);
		}
		
		private function takePhotoButtonClickHandler(event:MouseEvent):void
		{
			
		}
	}
}