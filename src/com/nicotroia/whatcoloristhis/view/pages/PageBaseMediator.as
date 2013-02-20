package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	
	import org.robotlegs.mvcs.Mediator;

	public class PageBaseMediator extends Mediator
	{
		[Inject]
		public var view:PageBase;
		
		override public function onRegister():void
		{
			eventDispatcher.addEventListener(NotificationEvent.APP_RESIZED, appResizedHandler);
		}
		
		protected function appResizedHandler(event:NotificationEvent):void
		{
			//override 
		}
	}
}