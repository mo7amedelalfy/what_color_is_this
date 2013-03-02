package com.nicotroia.whatcoloristhis.view.buttons
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import flash.events.MouseEvent;

	public class BackButtonMediator extends ButtonBaseMediator
	{
		[Inject]
		public var backButton:BackButton;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(backButton, MouseEvent.CLICK, welcomePageButtonClickHandler);
		}
		
		override protected function appResizedHandler(event:LayoutEvent):void
		{
			backButton.height = layoutModel.navBarHeight * 0.70;
			backButton.scaleX = backButton.scaleY;
			backButton.x = 14;
			backButton.y = (layoutModel.navBarHeight - backButton.height) * 0.5;
		}
		
		private function welcomePageButtonClickHandler(event:MouseEvent):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
	}
}