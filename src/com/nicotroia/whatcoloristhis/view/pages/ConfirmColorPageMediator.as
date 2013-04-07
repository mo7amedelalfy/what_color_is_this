package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import starling.events.Event;

	public class ConfirmColorPageMediator extends PageBaseMediator
	{
		[Inject]
		public var confirmColorPage:ConfirmColorPage;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			confirmColorPage.drawVectors(layoutModel, cameraModel);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Confirm Color"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, confirmColorPage.backButton));
			
			confirmColorPage.colorList.addEventListener(Event.CHANGE, colorListSelectedHandler);
			//confirmColorPage.colorList.addEventListener(Event.TRIGGERED, colorListSelectedHandler);
			confirmColorPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
		}
		
		private function colorListSelectedHandler(event:Event):void
		{
			trace("selected: 0x" + confirmColorPage.colorList.selectedItem.hex );
			
			cameraModel.chosenWinnerHex = confirmColorPage.colorList.selectedItem.hex;
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Result));
		}
		
		private function backButtonTriggeredHandler(event:Event):void
		{
			//i really hope the area select page info is saved
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_AreaSelect, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		override public function onRemove():void
		{
			confirmColorPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			
			confirmColorPage.reset();
			
			super.onRemove();
		}
	}
}