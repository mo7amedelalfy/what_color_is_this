package com.nicotroia.whatcoloristhis.view.buttons
{
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;

	public class ButtonBaseMediator extends Mediator
	{
		[Inject]
		public var view:ButtonBase;
		
		override public function onRegister():void
		{			
			//view.gotoAndStop(1);
			
			eventMap.mapListener(view, MouseEvent.ROLL_OVER, mouseOverHandler, MouseEvent, false, 0, true);
			eventMap.mapListener(view, MouseEvent.ROLL_OUT, mouseOutHandler, MouseEvent, false, 0, true);
			eventMap.mapListener(view, MouseEvent.MOUSE_DOWN, mouseDownHandler, MouseEvent, false, 0, true);
			eventMap.mapListener(view, MouseEvent.CLICK, viewClickHandler, MouseEvent, false, 0, true);
		}
		
		protected function mouseOverHandler(event:MouseEvent):void
		{
			view.overState();
		}
		
		protected function mouseOutHandler(event:MouseEvent):void
		{
			if( view.isEnabled ) { 
				view.upState();
			}
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			view.downState();
			
			//eventDispatcher.dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, SoundModel.BUTTON_BASE_DOWN_SOUND, 1.0));
			view.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			view.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			if( view.isEnabled ) { 
				view.upState();
			}
			//eventDispatcher.dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, SoundModel.BUTTON_BASE_UP_SOUND, 0.75));
		}
		
		protected function viewClickHandler(event:MouseEvent):void
		{
			//trace("button base clicked");
		}
		
	}
}