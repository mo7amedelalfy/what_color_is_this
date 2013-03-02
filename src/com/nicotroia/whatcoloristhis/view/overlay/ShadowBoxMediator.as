package com.nicotroia.whatcoloristhis.view.overlay
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;

	public class ShadowBoxMediator extends Mediator
	{
		[Inject]
		public var view:ShadowBoxView;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener(view, MouseEvent.CLICK, shadowBoxClickHandler);
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler, false, 0, true);
		}
		
		private function appResizedHandler(event:LayoutEvent):void
		{
			view.x = view.y = 0;
			view.redraw(contextView.stage.stageWidth, contextView.stage.stageHeight);
		}
		
		private function shadowBoxClickHandler(event:MouseEvent):void
		{
			//eventDispatcher.dispatchEvent(new InteractionEvent(InteractionEvent.SHADOW_BOX_CLICKED));
		}
	}
}