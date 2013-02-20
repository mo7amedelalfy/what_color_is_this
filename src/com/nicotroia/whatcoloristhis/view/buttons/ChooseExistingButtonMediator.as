package com.nicotroia.whatcoloristhis.view.buttons
{
	import flash.events.MouseEvent;

	public class ChooseExistingButtonMediator extends ButtonBaseMediator
	{
		[Inject]
		public var chooseExistingButton:ChooseExistingButton;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(chooseExistingButton, MouseEvent.CLICK, chooseExistingButtonClickHandler);
		}
		
		private function chooseExistingButtonClickHandler(event:MouseEvent):void
		{
			trace("choose a photo");
		}
	}
}