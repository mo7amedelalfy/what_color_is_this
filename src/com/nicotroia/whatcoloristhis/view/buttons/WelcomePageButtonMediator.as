package com.nicotroia.whatcoloristhis.view.buttons
{
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import flash.events.MouseEvent;

	public class WelcomePageButtonMediator extends ButtonBaseMediator
	{
		[Inject]
		public var welcomePageButton:WelcomePageButton;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(welcomePageButton, MouseEvent.CLICK, welcomePageButtonClickHandler);
		}
		
		private function welcomePageButtonClickHandler(event:MouseEvent):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
	}
}