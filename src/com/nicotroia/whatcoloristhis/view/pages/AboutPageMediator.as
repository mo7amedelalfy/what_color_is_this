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
			
			aboutPage.creditsTF.width = contextView.stage.stageWidth - 28;
			aboutPage.creditsTF.x = 14;
			aboutPage.creditsTF.y = layoutModel.navBarHeight + 14;
		}
	}
}