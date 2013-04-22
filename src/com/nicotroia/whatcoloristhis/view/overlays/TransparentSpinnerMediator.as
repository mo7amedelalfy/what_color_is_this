package com.nicotroia.whatcoloristhis.view.overlays
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import org.robotlegs.mvcs.StarlingMediator;

	public class TransparentSpinnerMediator extends StarlingMediator
	{
		[Inject]
		public var transparentSpinner:TransparentSpinner;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			if( ! transparentSpinner.hasBeenDrawn ) { 
				transparentSpinner.draw(layoutModel);
			}
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler, false, 0, true);
		}
		
		private function appResizedHandler(event:LayoutEvent):void
		{
			transparentSpinner.draw(layoutModel);
		}
	}
}