package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;

	public class AboutPageMediator extends PageBaseMediator
	{
		[Inject]
		public var aboutPage:AboutPage;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "About"));
		}
		
		override protected function appResizedHandler(event:LayoutEvent):void
		{
			trace("aboutPage resized");
			
			aboutPage.backButton.height = layoutModel.navBarHeight * 0.70;
			aboutPage.backButton.scaleX = aboutPage.backButton.scaleY;
			aboutPage.backButton.x = 14;
			aboutPage.backButton.y = (layoutModel.navBarHeight - aboutPage.backButton.height) * 0.5;
		}
	}
}