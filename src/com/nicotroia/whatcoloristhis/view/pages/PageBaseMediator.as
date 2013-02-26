package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;

	public class PageBaseMediator extends Mediator
	{
		[Inject]
		public var view:PageBase;
		
		override public function onRegister():void
		{
			appResizedHandler(null);
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler, false, 0, true);
		}
		
		protected function appResizedHandler(event:LayoutEvent):void
		{
			//override 
		}
		
		override public function onRemove():void
		{
			eventDispatcher.removeEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
		}
	}
}