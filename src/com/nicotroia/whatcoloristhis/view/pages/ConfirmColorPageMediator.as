package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	
	import flash.utils.setTimeout;
	
	import starling.events.Event;

	public class ConfirmColorPageMediator extends PageBaseMediator
	{
		[Inject]
		public var confirmColorPage:ConfirmColorPage;
		
		override protected function pageAddedToStageHandler(event:Event=null):void
		{
			super.pageAddedToStageHandler(event);
			
			//confirmColorPage.drawVectors(layoutModel, cameraModel);
			
			confirmColorPage.reset();
			
			confirmColorPage.drawConfirmationColors(layoutModel, cameraModel);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Confirm Color"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, confirmColorPage.backButton));
			
			confirmColorPage.colorList.addEventListener(Event.CHANGE, colorListSelectedHandler);
			//confirmColorPage.colorList.addEventListener(Event.TRIGGERED, colorListSelectedHandler);
			confirmColorPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
		}
		
		private function colorListSelectedHandler(event:Event):void
		{
			if( ! sequenceModel.isTransitioning ) { 
				trace("selected: 0x" + confirmColorPage.colorList.selectedItem.hex );
				
				cameraModel.chosenWinnerHex = confirmColorPage.colorList.selectedItem.hex;
				
				setTimeout( function():void { 
					eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Result));
				},1);
			}
			else { 
				//Clicked too early. Reset list, otherwise the item will select but page wont navigate
				List(event.target).selectedItem = null;
				List(event.target).validate();
			}
		}
		
		private function backButtonTriggeredHandler(event:Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_AreaSelect, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		override public function onRemove():void
		{
			confirmColorPage.colorList.removeEventListener(Event.CHANGE, colorListSelectedHandler);
			confirmColorPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			
			confirmColorPage.reset();
			
			super.onRemove();
		}
	}
}