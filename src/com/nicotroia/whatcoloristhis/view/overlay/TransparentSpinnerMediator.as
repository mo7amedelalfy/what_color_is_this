package com.nicotroia.whatcoloristhis.view.overlay
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	
	import org.robotlegs.mvcs.Mediator;

	public class TransparentSpinnerMediator extends Mediator
	{
		[Inject]
		public var transparentSpinner:TransparentSpinner;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler, false, 0, true);
		}
		
		private function appResizedHandler(event:LayoutEvent):void
		{
			transparentSpinner.x = (contextView.stage.stageWidth * 0.5) - (transparentSpinner.spinner.width * 0.5);
			transparentSpinner.y = (contextView.stage.stageHeight * 0.5) - (transparentSpinner.spinner.height * 0.5);
		}
	}
}