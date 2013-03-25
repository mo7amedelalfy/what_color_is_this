package com.nicotroia.whatcoloristhis.view.overlays
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.StarlingMediator;

	public class ShadowBoxMediator extends StarlingMediator
	{
		[Inject]
		public var view:ShadowBoxView;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			//eventMap.mapListener(view, MouseEvent.CLICK, shadowBoxClickHandler);
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
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
		
		override public function onRemove():void
		{
			eventDispatcher.removeEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
			
			super.onRemove();
		}
	}
}