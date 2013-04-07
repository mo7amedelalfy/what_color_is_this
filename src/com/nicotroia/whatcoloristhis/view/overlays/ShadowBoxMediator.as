package com.nicotroia.whatcoloristhis.view.overlays
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.StarlingMediator;

	public class ShadowBoxMediator extends StarlingMediator
	{
		[Inject]
		public var view:ShadowBoxView;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			//eventMap.mapListener(view, MouseEvent.CLICK, shadowBoxClickHandler);
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
		}
		
		private function appResizedHandler(event:LayoutEvent):void
		{
			var color:uint = Assets.getRandomColor();
			view.x = view.y = 0;
			view.draw(layoutModel.appWidth, layoutModel.appHeight, color);
			
			layoutModel.shadowBoxColor = color;
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