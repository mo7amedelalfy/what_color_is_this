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
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler, false, 0, true);
		}
		
		private function appResizedHandler(event:LayoutEvent):void
		{
			transparentSpinner.x = (layoutModel.appWidth * 0.5) - (transparentSpinner.spinner.width * 0.5);
			transparentSpinner.y = (layoutModel.appHeight * 0.5) - (transparentSpinner.spinner.height * 0.5);
		}
	}
}