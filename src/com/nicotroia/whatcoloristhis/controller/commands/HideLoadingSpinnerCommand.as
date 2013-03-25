package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.view.overlays.ShadowBoxView;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	import starling.display.Sprite;
	
	public class HideLoadingSpinnerCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject(name="overlayContainer")]
		public var overlayContainer:Sprite;
		
		[Inject]
		public var shadowBox:ShadowBoxView;
		
		[Inject]
		public var loadingSpinner:TransparentSpinner;
		
		override public function execute():void
		{
			trace("HideLoadingSpinnerCommand via " + event.type);
			
			loadingSpinner.notificationTF.text = '';
			
			//if( overlayContainer.contains(shadowBox) ) overlayContainer.removeChild(shadowBox);
			//if( overlayContainer.contains(loadingSpinner) ) overlayContainer.removeChild(loadingSpinner);
		}
	}
}